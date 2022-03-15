# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  # case_sensitive defaults to true, so need to say false

  passwordless_with :email
  # used with passwordless gem https://www.rubydoc.info/gems/passwordless/0.10.0

  def to_s
    "User #{id}: #{email}"
  end
end
