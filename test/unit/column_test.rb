require 'test_helper'

class ColumnTest < ActiveSupport::TestCase
  
  test "should create a column" do 
    column = Column.new
    column.title = "TODO"
    column.order = projects(:talkworking).columns.count + 1
    column.project = projects(:talkworking)
    column.color = "#CCCCCC"
    
    assert column.valid?
    assert column.save
    assert_equal 1, column.order
  end
  
  test "when create a column active should be true" do 
    column = Column.new
    column.title = "TODO"
    column.order = projects(:talkworking).columns.count + 1
    column.project = projects(:talkworking)
    column.color = "#CCCCCC"
    
    assert column.valid?
    assert column.save
    assert_equal 1, column.active
  end
  
  test "should create a two columns and ordered" do 
    column = Column.new
    column.title = "TODO"
    column.order = projects(:talkworking).columns.count + 1
    column.project = projects(:talkworking)
    column.color = "#CCCCCC"
    
    assert column.valid?
    assert column.save
    assert_equal 1, column.order
    
    column2 = Column.new
    column2.title = "TEST"
    column2.order = projects(:talkworking).columns.count + 1
    column2.project = projects(:talkworking)
    column2.color = "#CCCCCC"
    
    assert column2.valid?
    assert column2.save
    assert_equal 2, column2.order
  end
  
  test "should validate a column before save" do 
    column = Column.new
    
    assert !column.valid?
    assert !column.save
    
    assert column.errors[:title].any?
    assert column.errors[:order].any?
    assert column.errors[:color].any?
  end
  
  test "should validate a column color is rgb valid" do 
    column = Column.new
    column.title = "TODO"
    column.order = projects(:talkworking).columns.count + 1
    column.project = projects(:talkworking)
    column.color = "dsadsa"
    
    assert !column.valid?
    assert !column.save
    assert column.errors[:color].any?
  end
  
end
