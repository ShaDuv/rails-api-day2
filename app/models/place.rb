class Place < ApplicationRecord
  has_many :reviews, dependent: :destroy
  validates :name, presence: true
  validates :city, presence: true
  validates :country, presence: true

  scope :find_by_city, -> (city) { where("city ILIKE ?", "%#{city}%")}

  scope :find_by_country, -> (country) { where("country ILIKE ?", "%#{country}%")}

  scope :find_by_city_country, -> (city, country) { where("city ILIKE ? AND country ILIKE ?", "%#{city}%", "%#{country}%")}

  scope :avg_review, -> {
    select("places.id, places.name, places.city, places.country, AVG(reviews.id) AS reviews_avg")
    .joins(:reviews)
    .group("places.id")
    .order("reviews_avg DESC")
  }
end
