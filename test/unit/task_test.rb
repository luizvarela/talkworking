require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  
  test "should create a task" do
    t = Task.new
    t.title = "Title of task"
    t.end = Time.now.to_date
    t.user = users(:leonardo)
    t.task_list = task_lists(:buy_bread)
    t.task_type = task_types(:one)
    
    assert t.valid?
    assert t.save
  end
  
  test "when create a task active should be true" do 
    t = Task.new
    t.title = "Title of task"
    t.end = Time.now.to_date
    t.user = users(:leonardo)
    t.task_list = task_lists(:buy_bread)
    t.task_type = task_types(:one)
    
    assert t.valid?
    assert t.save
    assert_equal 1, t.active
  end
  
  test "should validate a task before save" do
    t = Task.new
    
    assert !t.valid?
    assert !t.save
    assert t.errors[:title].any?
    assert t.errors[:end].any?
  end
  
  test "should validate a end task date if is after now" do 
    t = Task.new
    t.title = "Title of task"
    t.user = users(:leonardo)
    t.task_list = task_lists(:buy_bread)
    t.end = Time.now.to_date - 10
    
    assert !t.valid?
    assert !t.save
    assert t.errors[:end].any?
  end
  
end
