class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.integer :topic_id
      t.text :content
      t.string :role

      t.timestamps
    end
  end
end
