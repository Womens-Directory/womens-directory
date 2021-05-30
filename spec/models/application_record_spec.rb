require 'rails_helper'

RSpec.describe ApplicationRecord do
  describe 'strips_spaces_from_string_fields' do
    it 'strips spaces from string and text fields on an object' do
      org = Org.create! name: '  Widgets Inc    ', desc: '  We sell high-quality widgets ', website: '  example.com '
      expect(org).to have_attributes name: 'Widgets Inc', desc: 'We sell high-quality widgets', website: 'example.com'
    end
  end
end
