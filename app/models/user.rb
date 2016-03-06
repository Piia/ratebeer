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
      favorite :style
    end

    def favorite_brewery
      favorite :brewery
    end

    def favorite(category)
      return nil if ratings.empty?

      rated = ratings.map{ |r| r.beer.send(category) }.uniq
      rated.sort_by { |item| -rating_of(category, item) }.first
    end

    def rating_of(category, item)
      ratings_of = ratings.select{ |r| r.beer.send(category)==item }
      ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
    end

    def self.top(n)
      sorted_by_rating_count_in_desc_order = User.all.sort_by{ |b| -(b.ratings.count||0) }
      sorted_by_rating_count_in_desc_order.first n
    end

    #def self.create_with_omniauth(auth)
    #  if User.find_by_username auth["info"]["name"]
    #  auth_name = "#{auth["info"]["name"]}+"
    #  else 
    #    auth_name = auth["info"]["name"]
    #  end
    #  user = User.new provider: auth["provider"], uid: auth["uid"], username: auth_name
    #  user.save(validate: false)
    #end


    


end
