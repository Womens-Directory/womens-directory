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

require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

class AnalyticsReport < ApplicationRecord
  def name
    age = time_ago_in_words(created_at)
    short_start_date = start_date.strftime("%Y-%m-%d")
    short_end_date = end_date.strftime("%Y-%m-%d")
    "Report #{id}: #{short_start_date} to #{short_end_date} (#{age} ago)"
  end

  def ready
    data.present?
  end
end
