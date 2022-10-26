class AddVisibleToOrg < ActiveRecord::Migration[6.1]
  def change
    add_column :orgs, :visible, :boolean, default: false, null: false
    Org.update_all 'visible = true'
  end
end
