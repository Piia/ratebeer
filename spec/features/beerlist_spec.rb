require 'rails_helper'

describe "beerlist page" do

  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost:true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = FactoryGirl.create(:style, name: "Lager", description: "fff")
    @style2 = FactoryGirl.create(:style, name: "Rauchbier", description: "fff")
    @style3 = FactoryGirl.create(:style, name: "Weizen", description: "fff")
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1, style: @style1)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3, style: @style3)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2, style: @style2)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows one known beer", js: true do
    visit beerlist_path
    find('table').find('tr:nth-child(2)')
    #save_and_open_page
    expect(page).to have_content "Nikolai"
  end

  it "shows beers in alphabetical order", js: true do
    visit beerlist_path
    #save_and_open_page
    expect(find('table').find('tr:nth-child(2)')).to have_content "Fastenbier"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Lechte Weisse"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Nikolai"
    
  end

  it "shows beers ordered by style", js: true do
    visit beerlist_path
    click_link "style"
    #save_and_open_page
    expect(find('table').find('tr:nth-child(2)')).to have_content "Nikolai"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Fastenbier"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Lechte Weisse"
  end

  it "shows beers ordered by brewery", js: true do
    visit beerlist_path
    click_link "brewery"
    #save_and_open_page
    expect(find('table').find('tr:nth-child(2)')).to have_content "Lechte Weisse"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Nikolai"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Fastenbier"
  end

    

end