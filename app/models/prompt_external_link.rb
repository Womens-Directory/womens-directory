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

end
