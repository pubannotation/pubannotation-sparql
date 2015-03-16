module HomeHelper
	def default_query
		if @query.present?
			@query
		else

<<HERE
PREFIX tao:<http://pubannotation.org/ontology/tao.owl#>
SELECT ?s1 ?s2 where {
	?s1 tao:followed_by ?s2 .
	?s1 tao:has_text "regulation" .
	?s2 tao:has_text "of" .
} LIMIT 10
HERE

		end
	end
end
