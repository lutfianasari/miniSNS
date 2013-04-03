class Member < ActiveRecord::Base
  attr_accessible :admin, :mail, :memo, :name, :pass, :user

  has_many :friend
  has_many :message
  has_many :comment
end
