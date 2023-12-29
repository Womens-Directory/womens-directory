class AddCmsPageRelationToAhoyEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :ahoy_events, :comfy_cms_page, foreign_key: { to_table: :comfy_cms_pages }
  end
end
