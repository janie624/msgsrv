class Message < ActiveRecord::Base
  attr_accessor :recipient_names
  attr_accessible :body, :subject, :recipient_ids
  has_many :recipients, :dependent => :destroy
  belongs_to :sender, :class_name => 'User'

  validates :body, :presence => true, :length => {:maximum => 320}
  validates :subject, :presence =>  true, :length => { :maximum => 255 }
  validates :recipients, :presence => true

  default_scope includes(:recipients).order('messages.created_at DESC')
  scope :sent, ->(user){ where(:sender_id => user.id) }
  scope :inbox, ->(user){ where({:message_recipients => {:user_id => user.id}}).where('message_recipients.deleted_at IS NULL') }
  scope :unread, ->(user) { inbox(user).where('message_recipients.read_at IS NULL') }

  def read!(user)
    recipients.find_by_user_id(user.id).update_attribute(:read_at, DateTime.now)
  end

  def read?(user)
    recipients.find_by_user_id(user.id).read_at?
  end

  def unread?(user)
    !read?(user)
  end

  def destroy(user)
    recipients.find_by_user_id(user.id).update_attribute(:deleted_at, DateTime.now)
  end

  def recipient_ids=(string)
    string.split(',').map do |id|
      if id.starts_with?('group')
        RecipientGroup.find_all_by(id).each do |group|
          group.users(sender).each do |user|
            self.recipients.build(:user => user)
          end
        end
      else
        self.recipients.build(:user_id => id)
      end
    end
  end

protected

end
