class AddRelationsToAhoyEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :ahoy_events, :category, foreign_key: true
    add_reference :ahoy_events, :feedback, foreign_key: true
    add_reference :ahoy_events, :location, foreign_key: true
    add_reference :ahoy_events, :org, foreign_key: true
  end
end
