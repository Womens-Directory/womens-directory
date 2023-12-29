class CreateAnalyticsReports < ActiveRecord::Migration[6.1]
  def change
    create_table :analytics_reports do |t|
      t.integer :version, null: false, default: 1
      t.references :user, null: false, foreign_key: true

      t.datetime :start_date, null: false
      t.datetime :end_date, null: false

      t.jsonb :data
      t.integer :gen_duration_secs

      t.timestamps
    end
  end
end
