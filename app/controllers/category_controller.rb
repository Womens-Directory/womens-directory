class CategoryController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @title = @category.name
    ahoy.track :category_viewed, category_id: @category.id
  end
end
