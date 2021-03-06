require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:style) {FactoryGirl.create :style}

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "is created normally" do
  	visit new_beer_path
  	fill_in('beer[name]', with:'olut')
    select('Tyyli', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

  end

  it "is not created when name is invalid and shows error message" do
  	visit new_beer_path
  	fill_in('beer[name]', with:'')
  	select('Tyyli', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')

    click_button "Create Beer"
    expect(Beer.count).to eq(0)

    expect(page).to have_content "Name can't be blank"

  end



end