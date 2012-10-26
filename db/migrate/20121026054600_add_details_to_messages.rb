class AddDetailsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :parent_message_id, :integer
    add_column :messages, :is_deleted,        :integer,  :limit => 2, :default => 0
  end
end
