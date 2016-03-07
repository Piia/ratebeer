class RatingsController < ApplicationController
	def index

      #Muutokset nopeuttivat sivun lataamista n. 100-kertaisesti. 

  		#@recent_ratings = Rating.recent
      Rails.cache.write("recent ratings", Rating.recent) if fragment_exist?("recent ratings")
      @recent_ratings = Rails.cache.read "recent ratings"

      #@top_breweries = Brewery.top 3
      Rails.cache.write("brewery top 3", Brewery.top(3)) if fragment_exist?("brewery top 3")
      @top_breweries = Rails.cache.read "brewery top 3"

      #@top_beers = Beer.top 3
      Rails.cache.write("beer top 3", Beer.top(3)) if fragment_exist?("beer top 3")
      @top_beers = Rails.cache.read "beer top 3"

      #@top_styles = Style.top 3
      Rails.cache.write("style top 3", Style.top(3)) if fragment_exist?("style top 3")
      @top_styles = Rails.cache.read "style top 3"

      #@top_users = User.top 3
      Rails.cache.write("user top 3", User.top(3)) if fragment_exist?("user top 3")
      @top_users = Rails.cache.read "user top 3"
      
  	end

   	def new
    	@rating = Rating.new
    	@beers = Beer.all
  	end

  	def create
      @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

      if current_user.nil?
        redirect_to signin_path, notice:'Please, sign in first'
      elsif @rating.save
        current_user.ratings << @rating
        redirect_to user_path current_user
      else
        @beers = Beer.all 
        render :new
      end
  	end

    def destroy
      rating = Rating.find(params[:id])
      rating.delete if current_user == rating.user
      redirect_to :back
    end


    
end