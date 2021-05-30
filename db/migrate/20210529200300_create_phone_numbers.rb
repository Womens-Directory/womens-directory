class CreatePhoneNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :phone_numbers do |t|
      t.belongs_to :location

      t.string :name
      t.string :number, null: false
      t.boolean :call, null: false, default: false
      t.boolean :sms, null: false, default: false
      t.boolean :always_open, null: false, default: false

      t.timestamps
    end
  end
end
