class Project < ActiveRecord::Base
  attr_accessible :description, :title, :active
  
  validates :title, :presence => true

  #ASSOCIATIONS
  has_and_belongs_to_many :users, :uniq => true
  has_many :task_lists
  has_many :columns
  has_many :task_types
  has_many :historical, :as => :historical
  
  #FILTER
  before_save :set_to_active
  
  #SCOPE
  default_scope where("active = 1")
  
  def set_to_active
    self.active = 1
  end
  
end
