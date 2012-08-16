class Column < ActiveRecord::Base
  attr_accessible :color, :order, :project_id, :title, :active
  
  #ASSOCIATIONS
  belongs_to :project
  has_many :tasks
  
  #VALIDATIONS
  validates :color, :order, :title, :presence => true
  validates :color, :format => {:with => /^\#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/ }
  
  #FILTER
  before_create :set_to_active
  
  #SCOPE
  default_scope where("active = 1")
  
  def self.default
    [Column.create(:title => I18n.t("columns.defaults.todo"), :color => "#FFFFFF", :order => 0),
     Column.create(:title => I18n.t("columns.defaults.doing"), :color => "#CCCCCC", :order => 1), 
     Column.create(:title => I18n.t("columns.defaults.done"), :color => "#FFFFFF", :order => 2)]
  end
  
  def set_to_active
    self.active = 1
  end
  
end
