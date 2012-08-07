class Task < ActiveRecord::Base
  attr_accessible :body, :column_id, :end, :task_list_id, :title, :user_id, :task_type_id,  :created_at, :updated_at, :active, :id
  
  #ASSOCIATIONS
  belongs_to :task_list
  belongs_to :column
  belongs_to :user
  belongs_to :task_type
  has_many :comments, :as => :comentavel
  has_many :historical, :as => :historical
  
  #VALIDATIONS
  validates :title, :task_type_id,  :presence => true
  validates :end, :date => { :after_or_equal_to => Proc.new { Time.now.to_date } }, :on => :create
  
  #FILTER
  before_save :set_to_active
  
  def set_to_active
    self.active = 1
  end
end
