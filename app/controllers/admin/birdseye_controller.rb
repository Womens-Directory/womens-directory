class Admin::BirdseyeController < Admin::BaseController
  def categories
    @cats = Category.all
  end

  def category
    @cat = Category.find params[:id]
    @locs = @cat.locations.order(:name)
  end
end
