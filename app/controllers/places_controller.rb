class PlacesController < ApplicationController
  def index
    city = params[:city]
    country = params[:country]
    if city && country
      @places = Place.find_by_city_country(city, country)
    elsif city
      @places = Place.find_by_city(city)
    elsif country
      @places = Place.find_by_country(country)
    else
      @places = Place.all
    end
    json_response @places
  end

  def show
    @place = Place.find params[:id]
    json_response @place
  end

  def create
    @place = Place.create! place_params
    json_response @place, :created
  end

  def update
    @place = Place.find params[:id]
    if @place.update! place_params
      render status: :ok, json: {
        message: "Place updated successfully!"
      }
    end
  end

  def destroy
    @place = Place.find params[:id]
    if @place.destroy!
      render status: :ok, json: {
        message: "Place destroyed successfully!"
      }
    end
  end

  def by_avg_review
    @place = Place.sort_by_avg_review
    json_response @place
  end

  private

  def place_params
    params.permit :name, :city, :country
  end
end
