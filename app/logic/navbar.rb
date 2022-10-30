# Navbar presents pages with a `show_in_top_nav` fragment.
# Add a `<!-- {{ cms:checkbox show_in_top_nav }} -->` to your Comfy layout to add this checkbox.
class Navbar
  class << self
    def items
      Rails.cache.fetch("navbar_#{page_count}_#{last_updated}") { pages }
    end

    private

    def page_count
      Comfy::Cms::Page.count
    end

    def last_updated
      Comfy::Cms::Page.maximum :updated_at
    end

    def pages
      ids = Comfy::Cms::Fragment.where(identifier: 'show_in_top_nav', boolean: true).pluck(:record_id)
      Comfy::Cms::Page.where(id: ids).order(:position).pluck(:label, :full_path)
    end
  end
end
