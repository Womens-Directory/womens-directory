class AddVisibleToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :visible, :boolean
  end
end
