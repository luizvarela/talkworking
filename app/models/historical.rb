class Historical < ActiveRecord::Base
  attr_accessible :description, :historical_id, :historical_type, :title, :project_id, :user_id
  
  belongs_to :user
  belongs_to :project
end
