require 'rails_helper'

RSpec.describe PhoneNumberDecorator do
  subject { pn.decorate }
  let(:org) { Org.create! name: 'My Org', desc: 'Some desc', website: 'example.com' }
  let(:loc) { Location.create! org: org, name: 'My Loc', desc: 'Some desc', website: 'example.com',
                               city: 'Denver', state: 'CO', zip: '80202' }
  let(:pn) { PhoneNumber.create! location: loc, number: number }

  context 'with a number containing ten digits' do
    let(:number) { '  612 555-1212? ' }

    it 'formats as an American phone number' do
      expect(subject.pretty).to eql '(612) 555-1212'
    end
  end

  context 'with a phone number that does not have 10 digits' do
    let(:number) { '+1.651.555.1212' }

    it 'returns the number verbatim' do
      expect(subject.pretty).to eql '+1.651.555.1212'
    end
  end
end
