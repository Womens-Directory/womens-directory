class Admin::BirdseyeController < Admin::BaseController
  def categories
    @cats = Category.all.order(:name)
  end

  def category
    @cat = Category.find params[:id]
    @locs = @cat.locations.eager_load(:phone_numbers).order(:name)
  end
end
