require 'rails_helper'

RSpec.describe "User Submissions", type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'with a new org' do
    it 'creates the submitted location' do
      visit '/submission'
      expect(page).to have_content 'Add Your Location'
    end
  end
end
