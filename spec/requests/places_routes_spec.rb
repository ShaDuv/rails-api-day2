require 'rails_helper'

describe 'get places route', type: :request do
  Place.destroy_all
  FactoryBot.create_list(:place, 20)

  before { get '/places'}

  it 'returns all places' do
    expect(JSON.parse(response.body).size).to eq(20)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end

describe 'post places route', type: :request do
  place_name = "Eifel Tower"
  place_city = "Paris"
  place_country = "France"
  before do
    Place.destroy_all
    post '/places', params: { name: place_name, city: place_city, country: place_country }
  end

  it 'creates a new place' do
    expect(Place.count).to eq(1)
    place = Place.all[0]
    expect(place.name).to eq(place_name)
    expect(place.city).to eq(place_city)
    expect(place.country).to eq(place_country)
  end

  it 'returns the created place' do
    body = JSON.parse(response.body)
    place = Place.all[0]
    expect(body["id"]).to eq(place.id)
    expect(body["name"]).to eq(place.name)
    expect(body["city"]).to eq(place.city)
    expect(body["country"]).to eq(place.country)
  end
end

describe 'get place route', type: :request do
  it 'returns the place with the given id' do
    place = FactoryBot.create(:place)

    get "/places/#{place.id}"
    body = JSON.parse(response.body)
    expect(body["id"]).to eq(place.id)
    expect(body["name"]).to eq(place.name)
    expect(body["city"]).to eq(place.city)
    expect(body["country"]).to eq(place.country)
  end
end
