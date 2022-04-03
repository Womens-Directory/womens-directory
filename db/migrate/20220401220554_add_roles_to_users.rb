class AddRolesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :roles_mask, :bigint, default: 0
  end
end
