PaperTrail::Rails::Engine.eager_load!

PaperTrail.config.track_associations = true

module PaperTrail
  class Version < ::ActiveRecord::Base
    include PaperTrail::VersionConcern

    belongs_to :user, foreign_key: :whodunnit, optional: true
  end
end
