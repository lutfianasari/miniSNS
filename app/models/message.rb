class Message < ActiveRecord::Base
  attr_accessible :content, :member_id

  belongs_to :member
  has_many :comment
end
