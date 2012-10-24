class Message::Recipient < ActiveRecord::Base

  belongs_to :message
  belongs_to :user

  scope :not_deleted, where("#{table_name}.deleted_at IS NULL")
  default_scope not_deleted

end
