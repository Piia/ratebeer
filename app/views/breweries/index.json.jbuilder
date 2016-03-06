json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.url brewery_url(brewery, format: :json)
  json.beers do
    json.count brewery.beers.count
  end
end
