require 'rails_helper'

RSpec.describe 'Submittable' do
  context 'with a submission with a org and location' do
    let!(:subm) do
      Submission.create!(
        contact_email: Faker::Internet.email,
        confirmation_token: 'doesnt_matter',
        confirmed: true,
      )
    end

    let!(:org) do
      Org.create!(
        submission: subm,
        name: Faker::Company.name,
        desc: Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 4),
        website: Faker::Internet.url,
      )
    end

    let!(:loc) do
      Location.create!(
        submission: subm,
        org: org,
        category_ids: Category.all,

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
    end

    let(:emails) { ActionMailer::Base.deliveries }
    let(:subjects) { emails.map(&:subject) }

    context 'when org and location have been accepted' do
      subject do
        org.update! visible: true
        loc.update! visible: true
      end

      it 'sends emails and deletes the submission' do
        expect { subject }.to change { Submission.count }.from(1).to(0)
        expect(subjects).to contain_exactly 'Submission accepted', 'Submission accepted'
      end
    end

    context 'when org has been accepted and location has been rejected' do
      subject do
        org.update! visible: true
        subm.reject! nil
      end

      it 'sends emails and deletes the submission' do
        expect { subject }.to change { Submission.count }.from(1).to(0)
        expect(subjects).to contain_exactly 'Submission accepted', 'Submission declined'
      end
    end

    context 'when org and location have been rejected' do
      subject { subm.reject! nil }

      it 'sends an email and deletes the submission' do
        expect { subject }.to change { Submission.count }.from(1).to(0)
        expect(subjects).to contain_exactly 'Submission declined'
      end
    end
  end
end
