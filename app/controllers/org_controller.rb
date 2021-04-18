class OrgController < ApplicationController
  def show
    @org = Org.find(params[:id])
  end
end
