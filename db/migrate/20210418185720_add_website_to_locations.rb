class AddWebsiteToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :website, :string
  end
end
