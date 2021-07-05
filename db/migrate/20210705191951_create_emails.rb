class CreateEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :emails do |t|
      t.string :address, null: false
      t.string :name
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
