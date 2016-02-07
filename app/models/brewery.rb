class Brewery < ActiveRecord::Base

  include AverageRating

  validates :name, presence: true
  validate :validate_year

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def validate_year
    if year > Time.now.year or year < 1042
      errors.add(:year, "must be between 1042 and this year")
    end
  end

	def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2016
    puts "changed year to #{year}"
  end

end
