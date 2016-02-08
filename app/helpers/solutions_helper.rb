module SolutionsHelper

	def solutions2span_annotations_urls (solutions, projects = nil, extension_size = 0, context_size = 0)
		projects ||= []
		projects = [projects] unless projects.respond_to?(:each)
		span_annotations_urls = []
		solutions.each_solution do |solution|
			span_urls = solution.to_h.values.select{|v| span?(v)}.map{|v| v.to_s}
			unless span_urls.empty?
				ranges = span_urls.map{|u| span_begin_end(u)}
				mbeg = ranges.map{|r| r[0]}.min - extension_size
				mend = ranges.map{|r| r[1]}.max + extension_size
				span_url = "#{span_prefix(span_urls[0])}#{mbeg}-#{mend}"
				span_annotations_url = span_url + '/annotations.json'
			  options = []
			  options << "context_size=#{context_size}" if context_size > 0
			  options << 'project=' + projects.join(',') if projects.present?
			  span_annotations_url += '?' + options.join('&') if options.present?
			  span_annotations_urls << [span_url, span_annotations_url]
			end
		end
		span_annotations_urls
	end

	def span?(v)
		!!(%r|/spans/\d+-\d+$|.match(v))
	end

	def span_prefix(span_url)
		span_url[0..span_url.rindex('/')]
	end

	def span_begin_end(span_url)
		span_url[span_url.rindex('/') + 1 .. -1].split('-').map{|p| p.to_i}
	end
end
