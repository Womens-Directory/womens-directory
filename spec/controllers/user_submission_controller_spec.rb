require 'rails_helper'

RSpec.describe UserSubmissionController::Params do
  subject { UserSubmissionController::Params.new params }

  context 'given an email address' do
    let(:params) { { loc_email: 'test@example.com' } }
    it 'builds the Email record' do
      expect(subject.emails.count).to eq 1
      expect(subject.emails.first.address).to eq 'test@example.com'
    end
  end

  context 'given a phone number' do
    let(:params) do
      {
        loc_phone: '555-555-5555',
        loc_phone_can_call: 'on',
        loc_phone_247: 'on',
      }
    end
    let(:pn) { subject.phone_numbers.first }

    it 'builds the PhoneNumber record' do
      expect(subject.phone_numbers.count).to eq 1
      expect(pn.number).to eq '555-555-5555'
      expect(pn.call).to eq true
      expect(pn.sms).to eq false
      expect(pn.always_open).to eq true
    end
  end

  context 'org' do
    let(:org) { subject.org }

    context 'given a new org' do
      let(:params) do
        {
          org_exists: 'false',
          org_name: 'Test Org',
          org_website: 'http://example.com',
          org_desc: 'Test Org Description',
        }
      end

      it 'builds the Org record' do
        expect(org.name).to eq 'Test Org'
        expect(org.website).to eq 'http://example.com'
        expect(org.desc).to eq 'Test Org Description'
      end
    end

    context 'given an existing org' do
      let(:org) do
        Org.create!(
          name: 'Test Org',
          website: 'http://example.com',
          desc: 'Test Org Description',
        )
      end
      let(:params) { { org_exists: 'true', org_id: org.id } }

      it 'fetches the existing Org record' do
        expect(org.id).to eq org.id
        expect(org.name).to eq 'Test Org'
        expect(org.website).to eq 'http://example.com'
        expect(org.desc).to eq 'Test Org Description'
      end
    end
  end

  context 'given category ids' do
    before do
      Category.create! id: 12, name: 'Test Category 1'
      Category.create! id: 24, name: 'Test Category 2'
      Category.create! id: 36, name: 'Test Category 3'
    end
    let(:params) { { loc_cat_12: 'on', loc_cat_36: 'on' } }
    it 'fetches the existing Category records' do
      expect(subject.categories).to contain_exactly Category.find(12), Category.find(36)
    end
  end

  context 'given a full form' do
    let(:params) do
      {
        org_exists: 'false',
        org_name: 'Test Org',
        org_website: 'http://example.com',
        org_desc: 'Test Org Description',

        loc_name: 'Test Location',
        loc_desc: 'Test Location Description',
        loc_website: 'http://example.com',
        loc_address1: '123 Main St',
        loc_address2: 'Suite 1',
        loc_city: 'Denver',
        loc_state: 'CO',
        loc_zip: '80202',

        loc_email: 'test@example.com',
        loc_phone: '555-555-5555',
        loc_phone_can_call: 'on',
        loc_phone_247: 'on',

        loc_cat_12: 'on',
        loc_cat_36: 'on',
      }
    end
    let(:email) { loc.emails.first }
    let(:pn) { loc.phone_numbers.first }
    let(:org) { loc.org }
    let(:loc) { subject.location }
    before do
      Category.create! id: 12, name: 'Test Category 1'
      Category.create! id: 24, name: 'Test Category 2'
      Category.create! id: 36, name: 'Test Category 3'
    end

    it 'builds the Location record' do
      expect(email.address).to eq 'test@example.com'
      expect(pn.number).to eq '555-555-5555'
      expect(org.name).to eq 'Test Org'

      expect(loc.name).to eq 'Test Location'
      expect(loc.desc).to eq 'Test Location Description'
      expect(loc.website).to eq 'http://example.com'
      expect(loc.address1).to eq '123 Main St'
      expect(loc.address2).to eq 'Suite 1'
      expect(loc.city).to eq 'Denver'
      expect(loc.state).to eq 'CO'
      expect(loc.zip).to eq '80202'

      expect(loc.categories).to contain_exactly Category.find(12), Category.find(36)
      expect(loc.valid?).to eq true
    end
  end
end
