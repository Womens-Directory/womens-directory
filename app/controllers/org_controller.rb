class OrgController < ApplicationController
  def show
    @org = Org.find(params[:id]).decorate
  end
end
