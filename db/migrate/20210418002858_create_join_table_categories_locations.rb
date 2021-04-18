class CreateJoinTableCategoriesLocations < ActiveRecord::Migration[6.1]
  def change
    create_join_table :categories, :locations do |t|
      t.index [:category_id, :location_id]
      t.index [:location_id, :category_id]
    end
  end
end
