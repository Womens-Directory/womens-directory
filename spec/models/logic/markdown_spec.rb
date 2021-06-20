RSpec.describe Markdown do
  describe '#escape' do
    subject { described_class.escape msg }

    context 'with a message containing Markdown control characters' do
      let(:msg) { 'This is a *fancy* Markdown message that [must be escaped](google.com).' }

      it { is_expected.to eql 'This is a \*fancy\* Markdown message that \[must be escaped]\(google\.com)\.' }
    end
  end
end
