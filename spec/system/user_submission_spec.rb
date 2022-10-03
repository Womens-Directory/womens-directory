require 'rails_helper'

RSpec.describe 'User Submission', type: :system do
  before do
    driven_by(:rack_test)
  end

  def fill_in_new_org
    choose 'org_exists_false'
    fill_in 'org[name]', with: 'ACME Womens Assistance'
    fill_in 'org[desc]', with: 'ACME Womens Assistance is a...'
    fill_in 'org[website]', with: 'https://acmewomens.org'
  end

  def fill_in_existing_org
    choose 'org_exists_true'
    select 'ACME Womens Assistance', from: 'org[id]'
  end

  def fill_in_location
    fill_in 'location[name]', with: 'ACME Womens Assistance - Denver'
    fill_in 'location[desc]', with: 'Our Denver location provides...'
    fill_in 'location[address1]', with: '123 Main St'
    fill_in 'location[address2]', with: 'Apt 2'
    fill_in 'location[city]', with: 'Los Angeles'
    fill_in 'location[state]', with: 'CA'
    fill_in 'location[zip]', with: '90012'
  end

  def expect_location_to_match
    expect(Location.last).to have_attributes(
      visible: false,
      name: 'ACME Womens Assistance - Denver',
      desc: 'Our Denver location provides...',
      address1: '123 Main St',
      address2: 'Apt 2',
      city: 'Los Angeles',
      state: 'CA',
      zip: '90012',
    )
  end

  it 'submits a location with a new org successfully' do
    visit '/submission'
    expect(page).to have_content 'Add Your Location'

    fill_in_location

    fill_in_new_org

    fill_in 'email[address]', with: 'denver@acmewomens.org'

    fill_in 'phone_number[number]', with: '555-555-5555'
    check 'phone_number[call]'
    check 'phone_number[always_open]'

    fill_in 'submission[contact_email]', with: 'outreach@acmewomens.org'
    fill_in 'submission[additional_notes]', with: 'Other stuff you need to know about this location...'

    expect { click_on 'Submit' }.
      to change { Location.count }.by(1).
      and change { Org.count }.by(1).
      and change { PhoneNumber.count }.by(1).
      and change { Email.count }.by(1).
      and change { Submission.count }.by(1)

    # TODO: check content of page

    expect_location_to_match

    expect(Org.last).to have_attributes(
      # visible: false, # TODO
      name: 'ACME Womens Assistance',
      desc: 'ACME Womens Assistance is a...',
      website: 'https://acmewomens.org',
    )
    expect(Location.last.org).to eq Org.last

    expect(PhoneNumber.last).to have_attributes(
      number: '555-555-5555',
      call: true,
      sms: false,
      always_open: true,
    )
    expect(Location.last.phone_numbers).to contain_exactly PhoneNumber.last

    expect(Email.last).to have_attributes(
      address: 'denver@acmewomens.org',
    )
    expect(Location.last.emails).to contain_exactly Email.last

    expect(Submission.last).to have_attributes(
      additional_notes: 'Other stuff you need to know about this location...',
      contact_email: 'outreach@acmewomens.org',
    )
    expect(Location.last.submission).to eql Submission.last
    # expect(Org.last.submission).to eql Submission.last # TODO: m2m poly?
  end

  it 'submits a location with a new org without optional data successfully' do
    visit '/submission'
    expect(page).to have_content 'Add Your Location'

    fill_in_location

    fill_in_new_org

    fill_in 'submission[contact_email]', with: 'outreach@acmewomens.org'

    expect { click_on 'Submit' }.
      to change { Location.count }.by(1).
      and change { Org.count }.by(1).
      and change { PhoneNumber.count }.by(0).
      and change { Email.count }.by(0).
      and change { Submission.count }.by(1)

    # TODO: check content of page

    expect_location_to_match

    expect(Org.last).to have_attributes(
      # visible: false, # TODO
      name: 'ACME Womens Assistance',
      desc: 'ACME Womens Assistance is a...',
      website: 'https://acmewomens.org',
    )
    expect(Location.last.org).to eq Org.last

    expect(Location.last.phone_numbers).to be_empty

    expect(Location.last.emails).to be_empty

    expect(Submission.last).to have_attributes(
      contact_email: 'outreach@acmewomens.org',
    )
    expect(Location.last.submission).to eql Submission.last
    # expect(Org.last.submission).to eql Submission.last # TODO: m2m poly?
  end

  context 'with an existing org' do
    before do
      Org.create!(
        name: 'ACME Womens Assistance',
        desc: 'ACME Womens Assistance is a...',
        website: 'https://acmewomens.org',
      )
    end

    it 'submits a location successfully' do
      visit '/submission'
      expect(page).to have_content 'Add Your Location'

      fill_in_location

      fill_in_existing_org

      fill_in 'submission[contact_email]', with: 'outreach@acmewomens.org'

      expect { click_on 'Submit' }.
        to change { Location.count }.by(1).
        and change { Org.count }.by(0).
        and change { PhoneNumber.count }.by(0).
        and change { Email.count }.by(0).
        and change { Submission.count }.by(1)

      # TODO: check content of page

      expect_location_to_match

      expect(Location.last.org).to eq Org.last

      expect(Location.last.phone_numbers).to be_empty

      expect(Location.last.emails).to be_empty

      expect(Submission.last).to have_attributes(
        contact_email: 'outreach@acmewomens.org',
      )
      expect(Location.last.submission).to eql Submission.last
    end
  end
end
