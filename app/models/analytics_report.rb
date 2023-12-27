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
    short_start_date = start_date.strftime('%Y-%m-%d')
    short_end_date = end_date.strftime('%Y-%m-%d')
    "Report #{id}: #{short_start_date} to #{short_end_date} (#{age} ago)"
  end

  def ready
    data.present?
  end

  def render
    by_id = data['views_by_id']
    location_ids = by_id['location'].keys
    cat_ids = by_id['cat'].keys | by_id['cat_loc'].keys
    org_ids = by_id['org'].keys
    cms_page_ids = by_id['cms_page'].keys

    locs = Location.where(id: location_ids).index_by(&:id)
    cats = Category.where(id: cat_ids).index_by(&:id)
    orgs = Org.where(id: org_ids).index_by(&:id)
    pages = Comfy::Cms::Page.where(id: cms_page_ids).index_by(&:id)

    result = {
      visit_count: data['visit_count'],
      event_count: data['event_count'],
      event_types: data['event_types'],
      views_by_id: {
        location: summarize(by_id['location'], locs),
        cat_loc: summarize(by_id['cat_loc'], cats),
        cat: summarize(by_id['cat'], cats),
        org: summarize(by_id['org'], orgs),
        cms_page: summarize(by_id['cms_page'], pages),
      }
    }
  end
end

def summarize(items, ids)
  items.
    map { |id, count| [ids[id.to_i], count] }.
    filter { |item| item.present? }.
    map { |item, count| item.to_report_summary.merge(count: count) }
end
