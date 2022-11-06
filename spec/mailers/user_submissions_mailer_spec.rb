require 'rails_helper'

describe UserSubmissionsMailer do
  describe 'reject' do
    subject { described_class.reject(subm, records, reason).deliver_now }
    let(:user) { 'harkness@westview.org' }
    let(:subm) { Submission.new contact_email: user }
    let(:records) {[
      double(class: Org, name: 'Westview Assistance Center'),
      double(class: Location, name: 'Downtown Office'),
    ]}
    let(:reason) { 'The city of Westview is a fictional location.' }
    let(:emails) { ActionMailer::Base.deliveries }
    let(:email) { emails.last }
    let(:body) { email.body.encoded.gsub("\r\n", "\n").strip }

    it 'sends the expected email' do
      expect { subject }.to change { emails.count }.by(1)
      expect(email.from).to eq ['submissions@womensdirectory.org']
      expect(email.to).to eq [user]
      expect(email.subject).to eq 'Submission declined'
      expected_body = <<~EOF
        Hello from Women's Directory,

        Sorry, but we've chosen not to add your submissions for Org: Westview Assistance Center, Location: Downtown Office to the website.

        The city of Westview is a fictional location.

        We appreciate your help, but due to our limited scope, we can't always add every organization or location to our site.

        Please contact us if you have any questions.

        Thanks,
        Women's Directory
        https://womensdirectory.org/
      EOF
      expect(body).to eq expected_body.strip
    end
  end
end
