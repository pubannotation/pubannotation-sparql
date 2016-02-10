class SolutionsController < ApplicationController
  def index
  	@ep_url						 = PubannotationSparql::Application.config.default_ep_url
		@default_graph_uri = params["default-graph-uri"]
		@query						 = params["query"]

    begin
			@projects = params.keys.select{|p| p.start_with?("project-")}.map{|p| p[8..-1]}
			raise "At least one annotation project has to be selected." if @projects.blank?

	    endpoint = SPARQL::Client.new(@ep_url)
			@solutions = if @default_graph_uri.nil? || @default_graph_uri.empty?
				endpoint.query(@query)
			else
				p = @default_graph_uri.rindex('/')
				@project = @default_graph_uri[p + 1 .. -1]
				endpoint.query(@query, "default-graph-uri" => @default_graph_uri)
			end

			@context_size = params[:context_size].present? ? params[:context_size].to_i : 0
			@extension_size = params["with annotation"].present? ?	@context_size : 0
			@context_size = 0 if @extension_size > 0

	    respond_to do |format|
	      format.html {render 'index'}
	      format.json {render json: @solutions}
	    end
		rescue => e
			message = e.message.split(%r|\n\n|)[0]
				respond_to do |format|
				format.html {redirect_to home_index_path(default_graph_uri: @default_graph_uri, query: @query), notice: message}
				format.json {render json: @solutions}
			end
		end

  end
end
