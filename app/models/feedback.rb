# == Schema Information
#
# Table name: feedbacks
#
#  id         :bigint           not null, primary key
#  body       :text
#  category   :string
#  ip         :string
#  path       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Feedback < ApplicationRecord
  has_many :events, class_name: 'Ahoy::Event'
  strips_spaces_from_string_fields
end
