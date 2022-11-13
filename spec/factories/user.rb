FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }

    factory :superadmin do
      roles { %i[superadmin] }
    end
  end
end
