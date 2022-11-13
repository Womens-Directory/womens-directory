FactoryBot.define do
  factory :org do
    name { Faker::Company.name }
    desc { Faker::Lorem.paragraph }
    visible { true }
    website { Faker::Internet.url }
  end
end
