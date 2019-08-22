require 'rails_helper'

describe 'get place_reviews route', type: :request do
  place = FactoryBot.create(:place_with_reviews)

  before { get "/places/#{place.id}/reviews" }

  it 'returns all reviews for the place with the given id' do
    expect(JSON.parse(response.body).size).to eq(place.reviews.count)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end

describe 'post place_reviews route', type: :request do
  new_user_name = "Ben"
  new_headline = "Whatchamacalis Exploriosum"
  new_body = "I am now a Whatchamacalis bar!"
  new_rating = 1
  place = FactoryBot.create(:place)
  review = nil

  before do
    place.reviews.destroy_all
    # binding.pry
    post "/places/#{place.id}/reviews", params: { user_name: new_user_name, headline: new_headline, body: new_body, rating: new_rating }
    place = Place.find(place.id)
    # binding.pry
    review = place.reviews[0]
  end

  it 'creates a new review' do
    expect(place.reviews.count).to eq(1)
    expect(review.user_name).to eq(new_user_name)
    expect(review.headline).to eq(new_headline)
    expect(review.body).to eq(new_body)
  end

  it 'returns the created review' do
    expect_json_to_eq_object(response, review)
  end
end

describe 'get place_review route', type: :request do
  it 'returns the review with the given id for the place with the given place_id' do
    place = FactoryBot.create(:place_with_reviews)
    review = place.reviews[0]

    get "/places/#{place.id}/reviews/#{review.id}"
    expect_json_to_eq_object(response, review)
  end
end

describe 'patch place_review route', type: :request do
  it 'updates the review with the given id for the place with the given place_id, using the given parameters' do
    place = FactoryBot.create(:place_with_reviews)
    review = place.reviews[0]
    new_user_name = "Ben"
    new_headline = "Whatchamacalis Exploriosum"
    new_body = "I am now a Whatchamacalis bar!"
    new_rating = 1
    patch "/places/#{place.id}/reviews/#{review.id}", params: { user_name: new_user_name, headline: new_headline, body: new_body, rating: new_rating }
    review = place.reviews.find(review.id)
    expect(review.user_name).to eq(new_user_name)
    expect(review.headline).to eq(new_headline)
    expect(review.body).to eq(new_body)
    expect(review.rating).to eq(new_rating)
  end
end

describe 'delete place_review route', type: :request do
  it 'destroys the review with the given id for the place with the given place_id' do
    place = FactoryBot.create(:place_with_reviews)
    review = place.reviews[0]
    delete "/places/#{place.id}/reviews/#{review.id}"
    expect(response).to have_http_status(:success)
    get "/places/#{place.id}/reviews/#{review.id}"
    expect(response).to have_http_status(:not_found)
  end
end

def expect_json_to_eq_object(json_response, review_object)
  body = JSON.parse(json_response.body)
  expect(body["user_name"]).to eq(review_object.user_name)
  expect(body["headline"]).to eq(review_object.headline)
  expect(body["body"]).to eq(review_object.body)
  expect(body["rating"]).to eq(review_object.rating)
  expect(body["place_id"]).to eq(review_object.place_id)
end
