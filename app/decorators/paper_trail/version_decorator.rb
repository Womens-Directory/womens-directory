class PaperTrail::VersionDecorator < Draper::Decorator
  # PaperTrail keeps record of how things in your database change any records
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::UrlHelper
  # ActionView is a namespace (helps organize code into groups) (for view related bits of code)

  HIDE_CHANGES_FOR = %w[created_at updated_at]

  delegate_all

  # these methods are used in the view and they live on a decorated version

  # item is a row in Versions table, item has column: item_type, constantize

  # Item 1: item_type => "Org"
  # item_type.constantize => Org
  # now you can do Org.find(42)
  # changes item type from string to class so that you query on it
  def item
    item_type.constantize.find item_id
  end

 # changes = everything that changed in one specific instant
 # e.g. zip_code from 80501 to 80222;
 #      hours from 8-5 to permanently closed
 # this method takes all the YAML changes and puts them in an easier hash to read
  def changes
    h = {}
    parse_changes.each do |k, v|
      # if the change is either the created at or updated attributes, skip them and continue
      next if HIDE_CHANGES_FOR.include? k
      # v = ['red', 'blue']
      # from, to = v # from = 'red', to = 'blue'
      from, to = v
      h[k] = [from, to]
    end
    h
  end

  # who made changes in database and what is their email
  def user_email
    whodunnit ? User.find(whodunnit).email : 'Unknown user'
  end

  # time_ago_in_words means how many minutes ago did something happen
  # this method is a summary of changes and outputs how long ago it happened, when it was created at,
  # the path, it outputs an html summary
  # html_safe avoids cross site scripting attacks, tells Rails that this string is safe
  def summary
    ago = "<span class=\"has-text-weight-bold\">#{time_ago_in_words created_at} ago:</span>"
    path = RailsAdmin::Engine.routes.url_helpers.show_path item.class.name.underscore.to_sym, item.id
    return [ago, user_email, "#{event}d", link_to(item, path)].join(' ').html_safe
  end

  private

  # ||= if you've done the thing to the left use that value otherwise generate the value using what is
  # on the right
  # @parse_changes || @parse_changes = YAML.load object_changes
  # YAML is a data interchange format like Json, load all object_changes and change into a ruby object
  def parse_changes
    @parse_changes ||= YAML.load object_changes
  end
end
