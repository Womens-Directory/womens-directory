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
  has_many :events, class_name: 'Ahoy::Event', dependent: :destroy
  belongs_to :visit, class_name: 'Ahoy::Visit'
  strips_spaces_from_string_fields
end

# why do you have to put class_name: 'Ahoy::Event'?
# how/where can I view what a category is for Feedback?
# why won't this work? rails c, Ahoy::Feedback.where.not(category: nil).first
# why doesn't strips_spaces_from_string_fields need to be attached to any object, how does it know when/where to work?


