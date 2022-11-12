require 'rails_helper'

RSpec.describe 'User Submission', type: :system do
  before do
    driven_by :rack_test

    Category.create! id: 1, name: 'Diapers'
    Category.create! id: 2, name: 'Energy Assistance'
    Category.create! id: 3, name: 'Food Banks'

    Org.create! visible: true, name: 'ACME Assistance', desc: '...', website: '...'
  end

  let(:admin_user) { User.create! email: 'contributor@womensdirectory.org', roles: %i[superadmin] }

  it 'works' do
    passwordless_sign_in admin_user
    visit admin_fresh_new_location_path
    expect(page).to have_content 'Create New Location'

    select 'ACME Assistance', from: 'Organization'
    fill_in 'location[name]', with: 'ACME Womens Assistance - Denver'
    fill_in 'location[desc]', with: 'Our Denver location provides...'
    fill_in 'location[city]', with: 'Los Angeles'
    select 'California', from: 'State'
    fill_in 'location[zip]', with: '90012'

    check 'Diapers'
    check 'Food Banks'

    expect { click_on 'Create Location' }.to change { Location.count }.by(1)
    expect(page).to have_content 'Location created successfully.'
    expect(Location.last).to be_visible
    expect(Location.last.categories).to contain_exactly Category.find(1), Category.find(3)
  end
end
