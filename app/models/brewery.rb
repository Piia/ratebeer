class Brewery < ActiveRecord::Base

  include AverageRating
  #include TopRated

  validates :name, presence: true
  validate :validate_year

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def validate_year
    if not year or year > Time.now.year or year < 1042
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

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order.first n
  end

end
