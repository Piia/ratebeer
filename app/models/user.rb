class User < ActiveRecord::Base

	include AverageRating

	has_secure_password

	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships

	validates :username, uniqueness: true, 
						length: {in: 3..16}
	validates :password, length: { minimum: 4 },
                       	format: {
                          with: /\d.*[A-Z]|[A-Z].*\d/,
                          message: "has to contain one number and one upper case letter"
                       }




    def favorite_beer
    	return nil if ratings.empty?   # palautetaan nil jos reittauksia ei ole
    	ratings.order(score: :desc).limit(1).first.beer 
  	end

  	def favorite_style
  		return nil if ratings.empty?
  		styles = {}
  		beers.each {|beer| styles[beer.style] = 0 if not styles.include?(beer.style)}
  		ratings.each{|r| styles[r.beer.style] += r.score}
  		styles.key(styles.values.max)
  	end

  	def favorite_brewery
  		return nil if ratings.empty?
  		breweries = {}
  		beers.each {|beer| breweries[beer.brewery.name] = 0 if not breweries.include?(beer.brewery.name)}
  		ratings.each{|r| breweries[r.beer.brewery.name] += r.score}
  		breweries.key(breweries.values.max).to_s
  	end
end
