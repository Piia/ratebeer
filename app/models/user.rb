class User < ActiveRecord::Base

	include AverageRating

	has_secure_password

	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships

	validates :username, uniqueness: true, length: {in: 3..16}
	validates :password, length: {minimum: 4}


end
