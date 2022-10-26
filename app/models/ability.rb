# frozen_string_literal: true

# These core data models are the ones used throughout the website that present visible information to end users.
CORE_DATA_MODELS = [
  Category,
  Location,
  Org,
  Email,
  PhoneNumber,
]

class Ability
  include CanCan::Ability

  # Use core_models_can to apply a permission to a user class for all of the core data models.
  def core_models_can(kind, except: [])
    CORE_DATA_MODELS
      .reject { |m| except.include? m }
      .each { |model| can kind, model }
  end

  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  def initialize(user)
    # Every user can sign into the admin dashboard.
    can :access, :rails_admin
    can :read, :dashboard

    # Every user can read all of the core models.
    core_models_can :read

    # Superadmins can do everything.
    if user.superadmin?
      can :manage, :all
    end

    # User inviters can invite new contributors.
    if user.user_inviter?
      can :invite, User
    end

    # CMS editors can manage all pages and content within the CMS.
    if user.cms_editor?
      can :manage, :cms
    end

    # Data editors can manage all core data on the site.
    if user.data_editor?
      core_models_can :manage
      can :manage, :user_submissions # You need access to Data Admin to accept a user submission
    end

    # Data contributors are able to create new Locations. Their locations will be hidden from public view until a
    # data editor approves them.
    if user.data_contributor?
      # Don't let contributors create new Categories. Creating everything else is fine.
      core_models_can :create, except: [Category]
    end
  end
end
