# == Schema Information
#
# Table name: submissions
#
#  id               :bigint           not null, primary key
#  additional_notes :text
#  contact_email    :string
#  owner_type       :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_id         :bigint           not null
#
# Indexes
#
#  index_submissions_on_contact_email  (contact_email)
#  index_submissions_on_owner          (owner_type,owner_id)
#
class Submission < ApplicationRecord
  belongs_to :owner, polymorphic: true
  # TODO: NOT NULL contact_email
end
