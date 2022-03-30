class Admin::BirdseyeController < Admin::BaseController
  # list all categories by alphabetical order
  def categories
    @cats = Category.all.order(:name)
  end

  # find the category id in the url and load locations for category
  # eager_load gets data now from database instead of requesting it later b. of n + 1 querying (it writes the correct query up front)
  def category
    @cat = Category.find params[:id]
    @locs = @cat.locations.eager_load(:phone_numbers).order(:name)
  end
end

# BirdsEye is admin view for categories and locations
