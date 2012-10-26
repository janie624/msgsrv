class AddDetailsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :parent_message_id, :integer
    add_column :messages, :deleted_at,        :timestamp
  end
end
