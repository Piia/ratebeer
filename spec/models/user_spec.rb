require 'rails_helper'

RSpec.describe User, type: :model do
  	it "has the username set correctly" do
    	user = User.new username:"Pekka"
    	expect(user.username).to eq("Pekka")
  	end

	it "is not saved without a password" do
    	user = User.create username:"Pekka"

    	expect(user).not_to be_valid
    	expect(User.count).to eq(0)
  	end

  	describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

	  	it "is saved with a proper password" do
	    	expect(user).to be_valid
	    	expect(User.count).to eq(1)
	  	end

	  	it "with a proper password and two ratings, has the correct average rating" do
			user.ratings << FactoryGirl.create(:rating)
	    	user.ratings << FactoryGirl.create(:rating2)

	    	expect(user.ratings.count).to eq(2)
	    	expect(user.average_rating).to eq(15.0)
	  	end
	end

	it "is not saved if password is too short" do
		user = User.create username:"Pekka", password:"Je1", password_confirmation:"Je1"
		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	it "is not saved if password includes only characters" do
		user = User.create username:"Pekka", password:"JeeJee", password_confirmation:"JeeJee"
		expect(user).not_to be_valid
		expect(User.count).to eq(0)
	end

	describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }
    let(:style){FactoryGirl.create :style}

		it "has method for determining the favorite_beer" do
	    	expect(user).to respond_to(:favorite_beer)
	  	end

	  	it "without ratings does not have a favorite beer" do
	    	expect(user.favorite_beer).to eq(nil)
	  	end

	  	it "is the only rated if only one rating" do
      		beer = create_beer(user, style, "noname", 10)
      		expect(user.favorite_beer).to eq(beer)
    	end

    	it "is the one with highest rating if several rated" do
      		create_beers(user, style, "noname", 10, 20, 15, 7, 9)
      		best = create_beer(user, style, "noname", 40)

      		expect(user.favorite_beer).to eq(best)
    	end

	end

	describe "favorite style" do
	let(:user){FactoryGirl.create(:user) }

		it "has method favorite_style" do
			expect(user).to respond_to(:favorite_style)
		end

		it "without ratings does not have a favorite style" do
	    	expect(user.favorite_style).to eq(nil)
	  	end

	  	it "is the one style when there is only one rating" do
	  		style = FactoryGirl.create :style
      		beer = create_beer(user, style, "noname", 10)
      		expect(user.favorite_style.name).to eq("Tyyli")
    	end

    	it "is highest rated style when there are many ratings" do
    		style1 = FactoryGirl.create :style
    		style2 = FactoryGirl.create :style, name:"IPA", description:"gjjhkh"
    		create_beers(user, style2, "noname", 10, 20, 15, 7, 9)
			create_beers(user, style1, "noname", 1, 2, 1, 7, 9)
			expect(user.favorite_style.name).to eq("IPA")
    	end

	end

	describe "favorite brewery" do
	let(:user){FactoryGirl.create(:user) }
		it "has method favorite_brewery" do
			expect(user).to respond_to(:favorite_brewery)
		end

		it "without ratings does not have a favorite brewery" do
	    	expect(user.favorite_brewery).to eq(nil)
	  	end

	  	it "is the one brewery when there is only one rating" do
	  		style = FactoryGirl.create :style
      		beer = create_beer(user, style, "noname", 10)
      		expect(user.favorite_brewery).to eq("noname")
    	end

    	it "is highest rated brewery when there are many ratings" do
    		style = FactoryGirl.create :style
    		create_beers(user, style, "Koff", 10, 20, 15, 7, 9)
    		create_beers(user, style, "BrewDog", 1, 2, 1, 7, 9)
    		expect(user.favorite_brewery).to eq("Koff")
    	end

	end



	def create_beers(user, style, brewery_name, *scores)
		scores.each do |score|
    		create_beer(user, style, brewery_name, score)
  		end
  	end

  	def create_beer(user, style, brewery_name, score)
  		brewery = FactoryGirl.create(:brewery, name: brewery_name)
  		beer = FactoryGirl.create(:beer, style: style, brewery: brewery)
    	FactoryGirl.create(:rating, score:score, beer:beer, user:user)
      	beer
    end





end