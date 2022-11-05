namespace :dev do
  task :test, [:count] => :environment do |_, args|
    ap args
  end

  desc 'Generate dummy user submissions for local testing'
  task :generate_dummy_submissions, [:count] => :environment do |_, args|
    raise 'Refusing to generate dummy user submissions outside of development' unless Rails.env.development?

    count = args[:count] ? args[:count].to_i : 1
    count.times do
      ApplicationRecord.transaction do
        subm = Submission.create!(
          additional_notes: 'Created by generate_dummy_submissions',
          contact_email: Faker::Internet.email,
          confirmation_token: 'doesnt_matter',
          confirmed: true,
        )

        org = nil
        if rand > 0.5
          org = Org.offset(rand(Org.count)).first
        else
          org = Org.create!(
            submission: subm,
            name: Faker::Company.name,
            desc: Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 4),
            website: Faker::Internet.url,
          )
        end
        ap org

        loc = Location.create!(
          submission: subm,
          org: org,
          category_ids: Category.pluck(:id).sample(3),

          name: Faker::Company.name,
          desc: Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 4),
          website: Faker::Internet.url,

          address1: Faker::Address.street_address,
          address2: Faker::Address.secondary_address,
          city: Faker::Address.city,
          state: Faker::Address.state,
          zip: Faker::Address.zip,
          neighborhood: rand < 0.8 ? Faker::Address.community : nil,
          latitude: Faker::Address.latitude,
          longitude: Faker::Address.longitude,
        )
        ap loc

        subm.location = loc
        ap subm
      end
    end
  end
end
