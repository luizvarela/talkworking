require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  
  test "should create a project" do
    p = Project.new
    p.title = "Title of project"
    p.description = "Description"
    
    assert p.valid?
    assert p.save
  end
  
  test "should validate title is presence" do 
    p = Project.new
    p.description = "Title of project"
    
    assert !p.valid?
    assert !p.save
    assert p.errors[:title].any?
  end
  
  test "when create a project active should be true" do 
     p = Project.new
     p.title = "Title of project"
     p.description = "Description"

     assert p.valid?
     assert p.save
     assert_equal 1, p.active
  end
  
  test "should validate association with user" do 
    p = Project.new
    p.title = "Title of project"
    p.description = "Description"

    assert p.valid?
    assert p.save
    assert_equal 0, p.users.count

    p.users << users(:jef)

    assert_equal 1, p.users.count

    p.users << users(:jef)
    assert_equal 1, p.users.count    
  end
end
