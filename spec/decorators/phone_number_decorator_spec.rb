require 'rails_helper'

RSpec.describe PhoneNumberDecorator do
  let(:org) { Org.create! name: 'My Org', desc: 'Some desc', website: 'example.com' }
  let(:loc) { Location.create! org: org, name: 'My Loc', desc: 'Some desc', website: 'example.com',
                               city: 'Denver', state: 'CO', zip: '80202' }
  let(:pn) { PhoneNumber.create!(location: loc, number: number, sms: sms, call: call).decorate }
  let(:sms) { true }
  let(:call) { true }

  describe '#pretty' do
    subject { pn.pretty }

    context 'with a number containing ten digits' do
      let(:number) { '  612 555-1212? ' }

      it 'formats as an American phone number' do
        expect(subject).to eql '(612) 555-1212'
      end
    end

    context 'with a phone number that does not have 10 digits' do
      let(:number) { '+1.651.555.1212' }

      it 'returns the number verbatim' do
        expect(subject).to eql '+1.651.555.1212'
      end
    end
  end

  describe 'URI methods' do
    let(:number) { '(612) 555-1212' }

    describe '#sms_uri' do
      subject { pn.sms_uri }
      it { is_expected.to eql 'sms:(612) 555-1212' }
    end

    describe '#tel_uri' do
      subject { pn.tel_uri }
      it { is_expected.to eql 'tel:(612) 555-1212' }
    end

    describe '#uri' do
      subject { pn.uri }

      context 'with a text-only number' do
        let(:sms) { true }
        let(:call) { false }
        it { is_expected.to eql 'sms:(612) 555-1212' }
      end

      context 'with a call-only number' do
        let(:sms) { false }
        let(:call) { true }
        it { is_expected.to eql 'tel:(612) 555-1212' }
      end

      context 'with a number that supports both calls and texts' do
        let(:sms) { true }
        let(:call) { true }
        it { is_expected.to eql 'tel:(612) 555-1212' }
      end
    end
  end
end
