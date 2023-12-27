class CreateVisitorIgnoreRules < ActiveRecord::Migration[6.1]
  def change
    create_table :visitor_ignore_rules do |t|
      t.string :pattern, null: false
      t.timestamps
    end

    create_table :visitor_ignores do |t|
      t.string :visitor_token, unique: true, null: false
      t.references :visitor_ignore_rule, foreign_key: true, null: false
    end
  end
end
