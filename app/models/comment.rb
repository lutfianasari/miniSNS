class Comment < ActiveRecord::Base
  attr_accessible :content, :member_id, :message_id

  belongs_to :member
  belongs_to :message
end
