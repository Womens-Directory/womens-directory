PaperTrail.config.track_associations = true
PaperTrail::Rails::Engine.eager_load!

module PaperTrail
  class Version < ::ActiveRecord::Base
    belongs_to :user, foreign_key: :whodunnit
  end
end
