class CreateSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :submissions do |t|
      t.references :owner, polymorphic: true, null: false
      t.string :contact_email
      t.text :additional_notes

      t.timestamps
    end
    add_index :submissions, :contact_email
  end
end
