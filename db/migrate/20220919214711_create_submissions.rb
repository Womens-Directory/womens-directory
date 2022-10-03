class CreateSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :submissions do |t|
      t.string :contact_email, null: false
      t.text :additional_notes, null: false, default: ''

      t.timestamps
    end
    add_index :submissions, :contact_email

    add_reference :locations, :submission, null: true, foreign_key: true
    add_reference :orgs, :submission, null: true, foreign_key: true
  end
end
