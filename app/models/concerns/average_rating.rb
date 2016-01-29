module AverageRating

	extend ActiveSupport::Concern

	def average_rating
		return ratings.sum(:score) / ratings.count
	end

end