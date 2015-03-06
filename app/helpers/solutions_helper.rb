module SolutionsHelper

	def solutions2span_annotations_urls (solutions, projects = nil, context_size = 0)
		projects ||= []
		projects = [projects] unless projects.respond_to?(:each)
		span_annotations_urls = []
		solutions.each_solution do |solution|
		  vars = solution.to_h.keys
		  s = solution[vars[0]].to_s
		  p = s.rindex('/')
		  url = s[0 .. p]
		  span = s[p + 1 .. -1]
		  mbeg, mend = span.split('-')
		  (1 ... vars.length).each do |i|
		    s = solution[vars[i]].to_s
		    p = s.rindex('/')
		    span = s[p + 1 .. -1]
		    sbeg, send = span.split('-')
		    mbeg = sbeg if sbeg < mbeg
		    mend = send if send > mend
		  end
		  span_url = url + mbeg + '-' + mend
		  span_annotations_url = span_url + '/annotations.json'
		  options = []
		  options << 'context_size=' + context_size if context_size > 0
		  options << 'project=[' + projects.join(',') + ']' if projects.present?
		  span_annotations_url += '?' + options.join('&') if options.present?
		  span_annotations_urls << [span_url, span_annotations_url]
		end
		span_annotations_urls
	end

end
