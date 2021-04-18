require 'rails_helper'

RSpec.describe "Orgs", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/org/show"
      expect(response).to have_http_status(:success)
    end
  end

end
