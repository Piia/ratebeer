require 'rails_helper'

RSpec.describe Beer, type: :model do
  
	it "is saved normally with a name and a style" do 
		beer = FactoryGirl.create :beer
		expect(beer.name).to eq("anonymous")
		expect(beer.style.name).to eq("Tyyli")
		expect(beer).to be_valid
	    expect(Beer.count).to eq(1)
	end

	it "is not saved without a name" do 
		style = FactoryGirl.create :style
		beer = Beer.create style: style
		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

	it "is not saved without a style" do 
		beer = Beer.create name:"olut"
		expect(beer).not_to be_valid
		expect(Beer.count).to eq(0)
	end

end
