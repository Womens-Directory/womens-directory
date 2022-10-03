class OrgController < ApplicationController
  def show
    @org = Org.find(params[:id]).decorate # TODO: only visible
    ahoy.track :org_viewed, org_id: @org.id
  end
end
