class AddIndexToAhoyVisitsVisitorToken < ActiveRecord::Migration[6.1]
  def change
    add_index :ahoy_visits, :visitor_token
  end
end
