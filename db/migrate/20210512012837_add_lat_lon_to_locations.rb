class AddLatLonToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :latitude, :decimal, precision: 9, scale: 6
    add_column :locations, :longitude, :decimal, precision: 9, scale: 6
  end
end
