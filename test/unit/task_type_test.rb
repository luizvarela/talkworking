require 'test_helper'

class TaskTypeTest < ActiveSupport::TestCase
  
  test "should create a task_type" do 
    tt = TaskType.new
    tt.title = "Task type"
    tt.color = "#CCCCCC"
    tt.project = projects(:talkworking)
    
    assert tt.valid?
    assert tt.save
  end
  
  test "when create a task type active should be true" do 
    tt = TaskType.new
    tt.title = "Task type"
    tt.color = "#CCCCCC"
    tt.project = projects(:talkworking)
    
    assert tt.valid?
    assert tt.save
    assert_equal 1, tt.active
  end
  
  test "should validate a task type before create" do 
    tt = TaskType.new
    
    assert !tt.valid?
    assert !tt.save
    assert tt.errors[:title].any?
    assert tt.errors[:color].any?
  end
  
  test "should validate a task type color is valid before create" do 
    tt = TaskType.new
    tt.title = "Task type"
    tt.color = "dsadsa"
    tt.project = projects(:talkworking)
    
    assert !tt.valid?
    assert !tt.save
    assert tt.errors[:color].any?
  end
  
end
