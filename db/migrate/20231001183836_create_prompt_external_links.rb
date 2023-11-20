class CreatePromptExternalLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :prompt_external_links do |t|
      t.text :link, null: false
      t.text :text, null: false

      t.timestamps
    end
  end
end
