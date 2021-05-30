require 'rails_helper'

RSpec.describe PhoneNumberDecorator do
  subject { pn.decorate }
  let(:pn) { PhoneNumber.create! number: number }

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
