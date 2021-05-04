class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.string :ip
      t.string :path
      t.string :category
      t.text :body

      t.timestamps
    end
  end
end
