require 'rails_helper'

describe 'place routes' do

  before(:each) { Place.destroy_all }

  describe 'get places route', type: :request do
    FactoryBot.create_list(:place, 20)

    before do
      FactoryBot.create_list(:place, 20)
      get '/places'
    end

    it 'returns all places' do
      expect(JSON.parse(response.body).size).to eq(20)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'post places route', type: :request do
    new_name = "Eifel Tower"
    new_city = "Paris"
    new_country = "France"

    before do
      post '/places', params: { name: new_name, city: new_city, country: new_country }
    end

    it 'creates a new place' do
      expect(Place.count).to eq(1)
      place = Place.all[0]
      expect(place.name).to eq(new_name)
      expect(place.city).to eq(new_city)
      expect(place.country).to eq(new_country)
    end

    it 'returns the created place' do
      place = Place.all[0]
      expect_json_to_eq_object(response, place)
    end
  end

  describe 'get place route', type: :request do
    it 'returns the place with the given id' do
      place = FactoryBot.create(:place)

      get "/places/#{place.id}"
      expect_json_to_eq_object(response, place)
    end
  end

  describe 'patch place route', type: :request do
    it 'updates the place with the given id using the given parameters' do
      place = FactoryBot.create(:place)
      new_name = "Eifel Tower"
      new_city = "Paris"
      new_country = "France"
      patch "/places/#{place.id}", params: { name: new_name, city: new_city, country: new_country }
      place = Place.find(place.id)
      expect(place.name).to eq(new_name)
      expect(place.city).to eq(new_city)
      expect(place.country).to eq(new_country)
    end
  end

  describe 'patch place route with missing parameter', type: :request do
    it 'updates the place with the given id using the given parameters' do
      place = FactoryBot.create(:place)
      new_name = "Eifel Tower"
      new_city = "Paris"
      patch "/places/#{place.id}", params: { name: new_name, city: new_city, country: "" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'delete place route', type: :request do
    it 'destroys the place with the given id' do
      place = FactoryBot.create(:place)
      delete "/places/#{place.id}"
      expect(response).to have_http_status(:success)
      get "/places/#{place.id}"
      expect(response).to have_http_status(:not_found)
    end
  end

  def expect_json_to_eq_object(json_response, place_object)
    body = JSON.parse(json_response.body)
    expect(body["id"]).to eq(place_object.id)
    expect(body["name"]).to eq(place_object.name)
    expect(body["city"]).to eq(place_object.city)
    expect(body["country"]).to eq(place_object.country)
  end
end
