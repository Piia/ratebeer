require 'rails_helper'

describe "Places" do
	it "if one is returned by the API, it is shown at the page" do
    	allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      		[ Place.new( name:"Oljenkorsi", id: 1 ) ]
    	)

    	visit places_path
    	fill_in('city', with: 'kumpula')
    	click_button "Search"

    	expect(page).to have_content "Oljenkorsi"
  	end

  	it "if multiple places, all are shown" do
  		allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      		[ Place.new( name: "baari", id: 1 ), 
      			Place.new( name: "bar", id: 2 ),
      			Place.new( name: "pub", id: 3 ) ]
    	)

    	visit places_path
    	fill_in('city', with: 'kumpula')
    	click_button "Search"

    	expect(page).to have_content "1 baari"
    	expect(page).to have_content "2 bar"
    	expect(page).to have_content "3 pub"
    	
  	end

  	it "if no places, proper notice is shown" do
  		allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      		[]
    	)

  		visit places_path
    	fill_in('city', with: 'kumpula')
    	click_button "Search"

    	expect(page).to have_content "No locations in kumpula"
  	end
end