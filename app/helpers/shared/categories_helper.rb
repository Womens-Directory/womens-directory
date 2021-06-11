module Shared::CategoriesHelper
  COLUMN_COUNT = 2

  def category_columns
    Category.where(visible: true).order(:name).in_groups(COLUMN_COUNT, false)
  end
end
