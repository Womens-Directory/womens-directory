class OrgController < ApplicationController
  # show the org and decorate sticks methods onto object so view can present the data and track with ahoy
  def show
    @org = Org.find(params[:id]).decorate
    ahoy.track :org_viewed, org_id: @org.id
  end
end
