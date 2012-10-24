class User < ActiveRecord::Base

  validates_uniqueness_of :email
  validates_presence_of :email, :message => " is required."
  validates_presence_of :first_name, :message => " is required."
  validates_presence_of :last_name, :message => " is required."

  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  attr_accessible :id, :first_name, :last_name, :email, :password, :password_confirmation

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def name=(name)
    self.first_name, self.last_name = name.split(' ')
  end

  def self.find_by_full_name!(full_name)
    result = where(["first_name || ' ' || last_name ILIKE ?", full_name]).first
    raise ActiveRecord::RecordNotFound unless result
    result
  end

end
