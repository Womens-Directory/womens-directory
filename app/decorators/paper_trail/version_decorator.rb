class PaperTrail::VersionDecorator < Draper::Decorator
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::UrlHelper

  HIDE_CHANGES_FOR = %w[created_at updated_at]

  delegate_all

  def item
    item_type.constantize.find item_id
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

  def user_email
    whodunnit ? User.find(whodunnit).email : 'Unknown user'
  end

  def summary
    ago = "<span class=\"has-text-weight-bold\">#{time_ago_in_words created_at} ago:</span>"
    path = RailsAdmin::Engine.routes.url_helpers.show_path item.class.name.underscore.to_sym, item.id
    return [ago, user_email, "#{event}d", link_to(item, path)].join(' ').html_safe
  end

  private

  def parse_changes
    @parse_changes ||= YAML.load object_changes
  end
end
