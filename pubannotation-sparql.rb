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

    endpoint = SPARQL::Client.new("http://rdf.pubannotation.org/sparql")
		@results = if default_graph_uri.nil? || default_graph_uri.empty?
			endpoint.query(query)
		else
			p = default_graph_uri.rindex('/')
			@project = default_graph_uri[p + 1 .. -1]
			endpoint.query(query, "default-graph-uri" => default_graph_uri)
		end

		erb :results, :trim => '-'
	end
end
