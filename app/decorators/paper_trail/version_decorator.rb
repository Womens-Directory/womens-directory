class PaperTrail::VersionDecorator < ApplicationDecorator
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::UrlHelper

  HIDE_CHANGES_FOR = %w[created_at updated_at]

  delegate_all

  def item
    item_type.constantize.find_by id: item_id
  end

  def changes
    h = {}
    parse_changes.each do |k, v|
      next if HIDE_CHANGES_FOR.include? k
      from, to = v
      h[k] = [from, to]
    end
    h
  end

  def submission
    return nil unless item.respond_to? :submission
    item.submission
  end

  def user_email
    return submission.contact_email if submission
    return User.find(whodunnit).email if whodunnit
    'System'
  end

  def event_proper
    return 'submitte' if event == 'create' && submission
    event
  end

  def summary
    ago = "<span class=\"has-text-weight-bold\">#{time_ago_in_words created_at} ago:</span>"
    return [ago, user_email, "#{event_proper}d", link_to(item, Route.admin_show_path_for(item), target: '_blank')].join(' ').html_safe
  end

  private

  def parse_changes
    @parse_changes ||= YAML.load object_changes, aliases: true, permitted_classes: [Time, BigDecimal, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone]
  end
end
