module TopRated

	extend ActiveSupport::Concern

	def self.top(n)
	   sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
	   # palauta listalta parhaat n kappaletta
	   # miten? ks. http://www.ruby-doc.org/core-2.1.0/Array.html
	end

end