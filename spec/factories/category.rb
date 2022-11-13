FactoryBot.define do
  factory :category do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    visible { true }
  end
end
