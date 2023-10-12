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
FactoryBot.define do
  factory :prompt_external_link do
    link { "MyText" }
    text { "MyText" }
  end
end
