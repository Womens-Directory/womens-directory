class CategoryController < ApplicationController
  def show
    @category = Category.find(params[:id])
    ahoy.track :category_viewed, category_id: @category.id
  end
end
