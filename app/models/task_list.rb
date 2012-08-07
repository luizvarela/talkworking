class TaskList < ActiveRecord::Base
  attr_accessible :description, :end_date, :name, :active
  
  #ASSOCIATIONS
  belongs_to :project
  has_many :tasks
  
  #SCOPE
  default_scope where("active = 1")
  scope   :current,  where(['end_date > ?', Time.now.to_date]).order(:end_date)
  
  #VALIDATIONS
  validates :name,  :presence => true
  validates :end_date, :date => { :after_or_equal_to => Proc.new { Time.now.to_date } }
  
  #FILTER
  before_save :set_to_active
  
  def set_to_active
    self.active = 1
  end
end
