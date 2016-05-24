module QueriesHelper
	def query_template(title)
		placeholders = title.scan(/{{[^}]+}}/)
		frags = title.split(/(__)/)
		placeholder = false
		template  = frags.collect do |f|
			if f == '__'
				placeholder = !placeholder
				nil
			elsif placeholder
				text_field_tag "__#{f}__", nil, placeholder:f, required:true
			else
				f
			end
		end.compact.join(' ').html_safe
	end
end
