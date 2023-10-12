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
require 'rails_helper'

RSpec.describe PromptExternalLink, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
