class AnonymizeFeedback < ActiveRecord::Migration[6.1]
  def change
    remove_column :feedbacks, :ip, :string
    add_column :feedbacks, :visit_id, :bigint
  end
end
