require 'rails_helper'

describe "BeermappingApi" do
    describe "in case of cache miss" do

    before :each do
      Rails.cache.clear
    end

        it "When HTTP GET returns one entry, it is parsed and returned" do

            canned_answer = <<-END_OF_STRING
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
            END_OF_STRING

            stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

            places = BeermappingApi.places_in("espoo")

            expect(places.size).to eq(1)
            place = places.first
            expect(place.name).to eq("Gallows Bird")
            expect(place.street).to eq("Merituulentie 30")
        end

        it "When HTTP GET returns no entry, places_in returns an empty array" do
            canned_answer = <<-END_OF_STRING
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
            END_OF_STRING

            stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

            places = BeermappingApi.places_in("espoo")

            expect(places.size).to eq(0)
        end

        it "When HTTP GET returns multiple entries, places_in returns them all as an array of Place instances" do
            canned_answer = <<-END_OF_STRING
        <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location>
        <location><id>12412</id><name>Olut</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location>
        <location><id>12413</id><name>Toinen</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
            END_OF_STRING

            stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

            places = BeermappingApi.places_in("espoo")
            expect(places.size).to eq(3)

            place1 = places[0]
            place2 = places[1]
            place3 = places[2]

            expect(place1.name).to eq("Gallows Bird")
            expect(place2.name).to eq("Olut")
            expect(place3.name).to eq("Toinen")
            
        end
    end

    describe "in case of cache hit" do

        it "When one entry in cache, it is returned" do
            # jos välimuistia ei tyhjennä tässä, siellä on edelleen edellisten testien romut
            # ja tässä halutaan laittaa omat romut välimuistiin ennen testaamista
            Rails.cache.clear 

            canned_answer = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
          END_OF_STRING

            stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

            # ensure that data found in cache
            BeermappingApi.places_in("espoo")

            places = BeermappingApi.places_in("espoo")

            #byebug
            expect(places.size).to eq(1)
            place = places.first
            expect(place.name).to eq("O'Connell's Irish Bar")
            expect(place.street).to eq("Rautatienkatu 24")
        end
  end

end