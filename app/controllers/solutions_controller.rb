class SolutionsController < ApplicationController
  def index
		default_graph_uri = params["default-graph-uri"]
		query						  = params["query"]

    endpoint = SPARQL::Client.new("http://rdf.pubannotation.org/sparql")

    begin
			@solutions = if default_graph_uri.nil? || default_graph_uri.empty?
				endpoint.query(query)
			else
				p = default_graph_uri.rindex('/')
				@project = default_graph_uri[p + 1 .. -1]
				endpoint.query(query, "default-graph-uri" => default_graph_uri)
			end

	    respond_to do |format|
	      format.html {render 'index'}
	      format.json {render json: @solutions}
	    end
		rescue => e
	    respond_to do |format|
	      format.html {redirect_to home_index_path, notice: e.message}
	      format.json {render json: @solutions}
	    end
		end

  end
end
