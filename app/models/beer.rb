class Beer < ActiveRecord::Base

	include AverageRating

	validates :name, presence: true
	validates :style, presence: true	

  	belongs_to :brewery
  	has_many :ratings, dependent: :destroy
  	has_many :raters, -> {uniq}, through: :ratings, source: :user
  	belongs_to :style

  	def to_s
  		return "#{self.name} #{self.brewery.name}"
  	end

end