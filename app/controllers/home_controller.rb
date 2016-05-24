class HomeController < ApplicationController
  def index
  	@ep_url						 = PubannotationSparql::Application.config.default_ep_url
		@default_graph_uri = params["default-graph-uri"]
		@template_id       = params[:template_id]
		@query						 = params["query"]

		unless @query.nil?
			@projects = ['bionlp-st-ge-2016-reference', 'bionlp-st-ge-2016-test']
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
		end

		unless @template_id.nil?
			template = Query.find(@template_id)
			@default_graph_uri = template.graph
			@title             = template.title
			@query             = template.sparql
			@comment           = template.comment
		end

		@queries = Query.order(:priority).all
		@path_prefix = PubannotationSparql::Application.config.relative_url_root || ''
  end
end
