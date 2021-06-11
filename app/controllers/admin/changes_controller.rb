class Admin::ChangesController < Admin::BaseController
  def changes
    @pagy, version_objects = pagy(PaperTrail::Version.order('created_at DESC'))
    @versions = version_objects.map &:decorate
  end
end
