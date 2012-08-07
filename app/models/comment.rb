class Comment < ActiveRecord::Base
  attr_accessible :comentavel_id, :comentavel_type, :content, :title, :user_id
  
  default_scope :order => "ID DESC"
  
  belongs_to :user
end
