class HomeController < ApplicationController
  def index
		@default_graph_uri = params["default-graph-uri"]
		@query						 = params["query"]

		@queries = Query.all
  end
end
