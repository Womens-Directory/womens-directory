class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :neighborhood
      t.string :address1
      t.string :address2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.text :desc, null: false
      t.references :org, null: false, foreign_key: true

      t.timestamps
    end
  end
end
