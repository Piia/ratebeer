class BeerClub < ActiveRecord::Base
	has_many :memberships
	has_many :members, through: :memberships, source: :user

	validates :name, presence: true
	validates :founded, presence: true
	validates :city, presence: true


end
