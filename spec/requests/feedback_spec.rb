require 'rails_helper'

RSpec.describe 'Feedback', type: :request do
  describe 'POST /feedback' do
    it 'persists feedback to the database' do
      params = {
        path: '/categories/123/locations/456',
        category: 'I have something else to suggest',
        body: "You're doing a great job. Keep it up!",
      }
      expect { post '/feedback', params: params }.to change { Feedback.count }.from(0).to(1)
      expect(response).to have_http_status :no_content
      expect(Feedback.last.as_json).to include(
        'path' => '/categories/123/locations/456',
        'category' => 'I have something else to suggest',
        'body' => "You're doing a great job. Keep it up!",
      )
    end
  end
end
