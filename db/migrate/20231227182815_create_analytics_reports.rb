class CreateAnalyticsReports < ActiveRecord::Migration[6.1]
  def change
    create_table :analytics_reports do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.jsonb :data

      t.timestamps
    end
  end
end
