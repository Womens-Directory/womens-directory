require 'rails_helper'

RSpec.describe "Volunteers", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get "/volunteer/home"
      expect(response).to have_http_status(:success)
    end
  end

end
