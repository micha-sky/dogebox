class AddCoordinatesToMeal < ActiveRecord::Migration
  def change
    add_column :meals, :description, :text
    add_column :meals, :latitude, :float, :limit => 30, :scale => 12
    add_column :meals, :longitude, :float, :limit => 30, :scale => 12
  end
end
