require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:style1) { FactoryGirl.create :style}
  let!(:style2) { FactoryGirl.create :style, name:"lager"}
  let!(:style3) { FactoryGirl.create :style, name:"porter"}
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style: style1 }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery, style: style2 }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "lists all ratings and shows the rating count" do
    ratings_that_have_beers_and_users
    visit ratings_path
    expect(page).to have_content "Number of ratings: #{@ratings.count}"
    @ratings.each do |rating|
      expect(page).to have_content rating
    end
  end

  it "shows all ratings of a user at that users page" do
    ratings_that_have_beers_and_users
    piia = FactoryGirl.create(:user, username: "Piia", password: "LoL1234", password_confirmation: "LoL1234")
    FactoryGirl.create(:rating, score: 5, user: piia, beer: beer2)

    visit user_path(user)

    expect(page).to have_content "#{user.username} Has #{@ratings.count}"

    @ratings.each do |rating|
      expect(page).to have_content rating
    end    

  end

  it "is deleted for good by clicking that ratings delete-link in users own page" do
    ratings_that_have_beers_and_users
    visit user_path(user)

    count = @ratings.count
    to_delete = Rating.find(2).to_s

    expect {
      find(:xpath, "(//a[text()='delete'])[2]").click
    }.to change{Rating.count}.from(count).to(count-1)

    expect(page).to_not have_content to_delete

  end

  describe "favourites" do
    it "beer" do

      FactoryGirl.create(:rating, score: 10, user: user, beer: beer1)
      FactoryGirl.create(:rating, score: 5, user: user, beer: beer2)

      visit user_path(user)
      expect(page).to have_content "Favorite beer: #{beer1.name}"
    end

    it "style" do
      # beer1 on Lager
      beer3 = FactoryGirl.create(:beer, name:"Karhu", style: style3, brewery:brewery)
      FactoryGirl.create(:rating, score: 10, user: user, beer: beer1)
      FactoryGirl.create(:rating, score: 5, user: user, beer: beer3)

      visit user_path(user)
      expect(page).to have_content "Favorite style: #{beer1.style.name}"
    end

    it "brewery" do
      brewdog = FactoryGirl.create(:brewery, name:"BrewDog") 
      # beer1 on Koffin
      beer3 = FactoryGirl.create(:beer, name:"Karhu", brewery:brewdog)
      ratings = [10, 7, 33, 44, 1, 22]
      ratings.each do |score|
        FactoryGirl.create(:rating, score: score, user: user, beer: beer1)
      end
      ratings = [1, 7, 3, 4, 1, 2]
      ratings.each do |score|
        FactoryGirl.create(:rating, score: score, user: user, beer: beer3)
      end

      visit user_path(user)
      expect(page).to have_content "Favorite brewery: #{beer1.brewery.name}"
    end

    
  end

end

def ratings_that_have_beers_and_users
  @ratings = [10, 7, 33, 44, 1, 22]
  @ratings.each do |score|
    FactoryGirl.create(:rating, score: score, user: user, beer: beer1)
  end
end





