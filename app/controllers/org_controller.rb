class OrgController < ApplicationController
  def show
    @org = Org.find(params[:id]).decorate
    ahoy.track :org_viewed, org_id: @org.id
  end
end
