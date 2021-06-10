class Admin::ChangesController < Admin::BaseController
  IGNORE_CHANGES_TO = %i[created_at updated_at]
  def changes
    @pagy, version_objects = pagy(PaperTrail::Version.order('created_at DESC'))
    @versions = version_objects.map do |o|
      changes = {}
      YAML.load(o.object_changes).each do |k, v|
        next if IGNORE_CHANGES_TO.include? k
        from, to = v
        changes[k] = [from, to]
      end
      {
        obj: o,
        changes: changes,
        item: o.item_type.constantize.find(o.item_id),
        user_email: o.whodunnit ? User.find(o.whodunnit).email : '<unknown>',
        at: o.created_at,
      }
    end
  end
end
