require 'rails_helper'

RSpec.describe 'User Submission', type: :system do
  before { driven_by :rack_test }

  let!(:cat_diapers) { create :category, name: 'Diapers' }
  let!(:cat_energy) { create :category, name: 'Energy Assistance' }
  let!(:cat_food) { create :category, name: 'Food Banks' }
  let!(:org) { create :org, name: 'ACME Assistance' }

  it 'works' do
    passwordless_sign_in create(:superadmin)
    visit admin_fresh_new_location_path
    expect(page).to have_content 'Create New Location'

    select 'ACME Assistance', from: 'Organization'
    fill_in 'location[name]', with: 'ACME Assistance - Los Angeles'
    fill_in 'location[desc]', with: 'Our Los Angeles location provides...'
    fill_in 'location[city]', with: 'Los Angeles'
    select 'California', from: 'State'
    fill_in 'location[zip]', with: '90012'

    check 'Diapers'
    check 'Food Banks'

    expect { click_on 'Create Location' }.to change { Location.count }.by(1)
    expect(page).to have_content 'Location created successfully.'
    expect(Location.last).to be_visible
    expect(Location.last.categories).to contain_exactly cat_diapers, cat_food
  end
end
