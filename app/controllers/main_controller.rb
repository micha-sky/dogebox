class MainController < ApplicationController
  def map

  end

  def index

  end

  def show
    meals = Meal.all
    render :json => meals.to_json
  end

  def create_meal
    name = params[:name]
    description = params[:description]
    latitude = params[:latitude]
    longitude = params[:longitude]

    meal = Meal.new(:name => name, :description => description,
    :longitude => longitude, :latitude => latitude)
    meal.save
    head :ok
  end
end
