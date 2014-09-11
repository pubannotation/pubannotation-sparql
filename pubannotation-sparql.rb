#!/usr/bin/env ruby
require 'sinatra/base'
require 'sparql/client'
require 'erb'

class PubAnnotationSPARQL < Sinatra::Base

	get '/' do
		erb :index
	end

	get '/sparql' do
		default_graph_uri = params["default-graph-uri"]
		query						  = params["query"]

		p = default_graph_uri.rindex('/')
		@project = default_graph_uri[p + 1 .. -1]

    endpoint = SPARQL::Client.new("http://sparql.pubannotation.org/sparql")
		@results = endpoint.query(query, "default-graph-uri" => default_graph_uri)

		erb :results, :trim => '-'
	end
end
