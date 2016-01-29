class Beer < ActiveRecord::Base

	include AverageRating

  	belongs_to :brewery
  	has_many :ratings, dependent: :destroy

  	def to_s
  		return "#{self.name} #{self.brewery.name}"
  	end

end