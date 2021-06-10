class AddHiddenToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :visible, :boolean, default: true, null: false
  end
end
