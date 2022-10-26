module Shared::CategoriesHelper
  COLUMN_COUNT = 2

  def category_columns
    Category.visible.order(:name).in_groups(COLUMN_COUNT, false)
  end
end
