class AddDescriptionToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :description, :text
  end
end
