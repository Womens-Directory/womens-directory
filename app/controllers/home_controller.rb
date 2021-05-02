class HomeController < ApplicationController
  COLUMN_COUNT = 2

  def home
    @columns = Category.all.order(:name).in_groups(COLUMN_COUNT, false)
  end
end
