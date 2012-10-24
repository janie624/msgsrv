class CreateMessageRecipients < ActiveRecord::Migration
  def change
    create_table :message_recipients do |t|
      t.integer :message_id
      t.integer :user_id
      t.timestamp :deleted_at
      t.timestamp :read_at

      t.timestamps
    end
  end
end
