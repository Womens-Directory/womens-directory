# frozen_string_literal: true
# if you write a string in this file, ruby won't let you change it, to prevent you from mutating a constant like a key

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

  # Use core_models_can to apply a permission to a user class for all of the core data models. ( kind is any actions such as :read)
  def core_models_can(kind, except: [])
    CORE_DATA_MODELS
     # does the except array include m?
      .reject { |m| except.include? m }
      # the action is permitted on this model
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

    # User editors can invite and edit users.
    if user.user_editor?
      # TODO: Users should not be able to edit other user editors
      can :manage, User
    end

    # CMS editors can manage all pages and content within the CMS.
    if user.cms_editor?
      can :manage, :cms
    end

    # Data editors can manage all core data on the site.
    if user.data_editor?
      core_models_can :manage
    end

    # Data contributors are able to create new Locations. Their locations will be hidden from public view until a
    # data editor approves them.
    if user.data_contributor?
      # Don't let contributors create new Categories. Creating everything else is fine.
      core_models_can :create, except: [Category]
    end
  end
end
