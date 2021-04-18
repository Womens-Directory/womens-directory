class CreateOrgs < ActiveRecord::Migration[6.1]
  def change
    create_table :orgs do |t|
      t.string :name, null: false
      t.string :website, null: false
      t.text :desc, null: false

      t.timestamps
    end
  end
end

