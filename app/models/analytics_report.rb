# == Schema Information
#
# Table name: analytics_reports
#
#  id                :bigint           not null, primary key
#  data              :jsonb
#  end_date          :datetime         not null
#  gen_duration_secs :integer
#  start_date        :datetime         not null
#  version           :integer          default(1), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_analytics_reports_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

class AnalyticsReport < ApplicationRecord
  belongs_to :user

  def name
    age = time_ago_in_words(created_at)
    short_start_date = start_date.strftime('%Y-%m-%d')
    short_end_date = end_date.strftime('%Y-%m-%d')
    "#{id}: #{short_start_date} to #{short_end_date} (#{age} ago)"
  end

  def ready
    data.present?
  end

  def render
    location_ids = data['total_views']['location'].keys
    cat_ids = data['total_views']['cat'].keys | data['total_views']['cat_loc'].keys
    org_ids = data['total_views']['org'].keys
    cms_page_ids = data['total_views']['cms_page'].keys

    locs = Location.where(id: location_ids).index_by(&:id)
    cats = Category.where(id: cat_ids).index_by(&:id)
    orgs = Org.where(id: org_ids).index_by(&:id)
    pages = Comfy::Cms::Page.where(id: cms_page_ids).index_by(&:id)

    result = {
      visit_count: data['visit_count'],
      visit_count_by_date: data['visit_count_by_date'],
      event_count: data['event_count'],
      event_types: data['event_types'],
      total_views: {
        location: summarize(data['total_views']['location'], locs),
        cat_loc: summarize(data['total_views']['cat_loc'], cats),
        cat: summarize(data['total_views']['cat'], cats),
        org: summarize(data['total_views']['org'], orgs),
        cms_page: summarize(data['total_views']['cms_page'], pages),
      },
      views_by_visit: {
        location: summarize(data['views_by_visit']['location'], locs),
        cat_loc: summarize(data['views_by_visit']['cat_loc'], cats),
        cat: summarize(data['views_by_visit']['cat'], cats),
        org: summarize(data['views_by_visit']['org'], orgs),
        cms_page: summarize(data['views_by_visit']['cms_page'], pages),
      },
      views_by_visitor: {
        location: summarize(data['views_by_visitor']['location'], locs),
        cat_loc: summarize(data['views_by_visitor']['cat_loc'], cats),
        cat: summarize(data['views_by_visitor']['cat'], cats),
        org: summarize(data['views_by_visitor']['org'], orgs),
        cms_page: summarize(data['views_by_visitor']['cms_page'], pages),
      },
    }
  end
end

def summarize(items, ids)
  items.
    map { |id, count| [ids[id.to_i], count] }.
    filter { |item| item.present? }.
    map { |item, count| item.to_report_summary.merge(count: count) }
end
