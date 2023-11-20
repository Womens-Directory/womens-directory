# == Schema Information
#
# Table name: prompt_external_links
#
#  id         :bigint           not null, primary key
#  link       :text             not null
#  text       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PromptExternalLink < ApplicationRecord
  validates_presence_of :link, :text
  validates :link, 
    format: { with: /\A(https:\/\/)/,
              message: "A valid link was not provided. It must start with 'https://'" }
  validates :text, length: { minimum: 1 }
end
