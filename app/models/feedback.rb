# == Schema Information
#
# Table name: feedbacks
#
#  id         :bigint           not null, primary key
#  body       :text
#  category   :string
#  path       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  visit_id   :bigint
#
class Feedback < ApplicationRecord
  has_many :events, class_name: 'Ahoy::Event'
  belongs_to :visit, class_name: 'Ahoy::Visit'
  strips_spaces_from_string_fields
end
