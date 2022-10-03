# == Schema Information
#
# Table name: submissions
#
#  id               :bigint           not null, primary key
#  additional_notes :text             default(""), not null
#  contact_email    :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_submissions_on_contact_email  (contact_email)
#
class Submission < ApplicationRecord
  has_one :location
  has_one :org
end
