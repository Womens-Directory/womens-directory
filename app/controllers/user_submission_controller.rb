class UserSubmissionController < ApplicationController
  def form
    @cats = Category.all.order(:name)
    @orgs = Org.all.order(:name)
  end

  def create
    @params = params
  end
end
