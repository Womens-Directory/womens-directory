# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  roles_mask :bigint           default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  include RoleModel
  roles_attribute :roles_mask
  # Do not reorder this list! Add new roles at the BOTTOM of the list only!
  roles %i[
    superadmin
    user_editor
    cms_editor
    data_editor
    data_contributor
  ]

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  passwordless_with :email

  def to_s
    "User #{id}: #{email}"
  end

  # can? is a shorthand for checking CanCanCan permissions, e.g. `user.can? :create, Location # => true`
  def can?(*args, **kwargs)
    Ability.new(self).can? *args, **kwargs
  end
end
