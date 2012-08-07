class Suggestion < ActiveRecord::Base
  attr_accessible :body, :user_id
  
  validates :body, :presence => true
  
  belongs_to :user
end
