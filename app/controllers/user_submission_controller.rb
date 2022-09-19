class UserSubmissionController < ApplicationController
  def form
    @services = Category.all.order(:name)
  end

  def create
    @params = params
  end
end
