require 'test_helper'

class TaskListTest < ActiveSupport::TestCase
  
  test "sould create a task list associated a one project" do 
    tl = TaskList.new
    tl.name = "TaskList test"
    tl.description = "This is task list test"
    tl.end_date = Time.now
    tl.project = projects(:talkworking)
    
    assert tl.valid?
    assert tl.save
    assert_equal TaskList.last.project.id, projects(:talkworking).id
  end
  
  test "should validate name is presence a task list" do 
    tl = TaskList.new
    tl.description = "Task list description"
    tl.end_date = Time.now
    tl.project = projects(:talkworking)
    
    assert !tl.valid?
    assert !tl.save
    assert tl.errors[:name].any?
  end
  
  test "when create a task list active should be true" do 
    tl = TaskList.new
    tl.name = "TaskList test"
    tl.description = "This is task list test"
    tl.end_date = Time.now
    tl.project = projects(:talkworking)
    
    assert tl.valid?
    assert tl.save
    assert_equal 1, tl.active
  end
  
  test "should validate date is a valid date" do 
    tl = TaskList.new
    tl.description = "TaskList test"
    tl.name = "Name of tasklist"
    tl.end_date = "1234"
    
    assert !tl.valid?
    assert !tl.save
    assert tl.errors[:end_date].any?
  end
  
  test "should validate date if date after Time.now" do 
    tl = TaskList.new
    tl.description = "TaskList description"
    tl.name = "Name of tasklist"
    tl.end_date = Time.now.to_date - 1
    
    assert !tl.valid?
    assert !tl.save
    assert tl.errors[:end_date].any?
  end
  
end
