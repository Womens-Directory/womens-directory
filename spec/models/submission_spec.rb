# == Schema Information
#
# Table name: submissions
#
#  id                 :bigint           not null, primary key
#  additional_notes   :text             default(""), not null
#  confirmation_token :string           not null
#  confirmed          :boolean          default(FALSE), not null
#  contact_email      :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_submissions_on_contact_email  (contact_email)
#
require 'rails_helper'

describe Submission, type: :model do
  describe '#reject!' do
    subject { subm.reject! true, reason }
    let(:subm) { Submission.create! contact_email: 'harkness@westview.org', confirmation_token: 'dont_care' }
    let(:reason) { nil }

    let(:emails) { ActionMailer::Base.deliveries }
    let(:email) { emails.last }

    before do
      org = Org.create!(
        submission: subm,
        name: Faker::Company.name,
        desc: Faker::Lorem.paragraph(sentence_count: 3, random_sentences_to_add: 4),
        website: Faker::Internet.url,
      )

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

    it 'destroys targets and sends an email' do
      expect { subject }.
        to change { Submission.count }.by(-1).
        and change { Org.count }.by(-1).
        and change { Location.count }.by(-1).
        and change { emails.count }.by(1)
      expect(email.subject).to eq 'Submission declined'
    end
  end
end
