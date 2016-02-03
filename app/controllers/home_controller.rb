class HomeController < ApplicationController
  def index
  	@ep_url						 = PubannotationSparql::Application.config.default_ep_url
		@default_graph_uri = params["default-graph-uri"]
		@query						 = params["query"]

		unless @query.present?
			default_query = Query.find_by_priority(1)
			@default_graph_uri = default_query.graph
			@query             = default_query.sparql
			@comment           = default_query.comment
		end

		@graphs = PubannotationSparql::Application.config.graphs
		@prefixes = PubannotationSparql::Application.config.prefixes
		@queries = Query.order(:priority).all
		@path_prefix = PubannotationSparql::Application.config.relative_url_root || ''
  end
end
