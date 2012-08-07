class TaskType < ActiveRecord::Base
  attr_accessible :color, :project_id, :title
  
  #ASSOCIATIONS
  belongs_to :project
  has_many :tasks
  
  #SCOPE
  default_scope where("active = 1")
  
  #VALIDATIONS
  validates :color, :title, :presence => true
  validates :color, :format => {:with => /^\#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/ }
  
  def self.default
    [TaskType.create(:title => I18n.t("tasktypes.defaults.new_feature"), :color => "#87CEFA"), 
     TaskType.create(:title => I18n.t("tasktypes.defaults.bug"), :color => "#FF6347")]
  end
  
  #FILTER
  before_save :set_to_active

  def set_to_active
    self.active = 1
  end
  
end
