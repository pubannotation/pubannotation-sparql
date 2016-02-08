class SolutionsController < ApplicationController
  def index
  	@ep_url						= PubannotationSparql::Application.config.default_ep_url
		default_graph_uri = params["default-graph-uri"]
		query						  = params["query"]

    endpoint = SPARQL::Client.new(@ep_url)

    begin
			@solutions = if default_graph_uri.nil? || default_graph_uri.empty?
				endpoint.query(query)
			else
				p = default_graph_uri.rindex('/')
				@project = default_graph_uri[p + 1 .. -1]
				endpoint.query(query, "default-graph-uri" => default_graph_uri)
			end

			@projects = PubannotationSparql::Application.config.projects_to_show
			@context_size = params[:context_size].present? ? params[:context_size].to_i : 0

	    respond_to do |format|
	      format.html {render 'index'}
	      format.json {render json: @solutions}
	    end
		rescue => e
			message = e.message.split(%r|\n\n|)[0]
	    respond_to do |format|
	      format.html {redirect_to home_index_path(default_graph_uri: default_graph_uri, query: query), notice: message}
	      format.json {render json: @solutions}
	    end
		end

  end
end
