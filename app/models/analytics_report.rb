# == Schema Information
#
# Table name: analytics_reports
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  end_date   :datetime         not null
#  start_date :datetime         not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AnalyticsReport < ApplicationRecord
end
