class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.text :body
      t.string :subject
      t.timestamps
    end
  end
end
