class HomeController < ApplicationController
  def index
		@default_graph_uri = params["default-graph-uri"]
		@query						 = params["query"]

		unless @query.present?
			default_query = Query.find_by_priority(1)
			@default_graph_uri = default_query.graph
			@query             = default_query.sparql
			@comment           = default_query.comment
		end

		@queries = Query.order(:priority).all
  end
end
