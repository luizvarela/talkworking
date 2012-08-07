require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "should create a new user" do 
    u = User.new
    u.email = "email@email.com"
    u.password = "email"
    
    assert u.valid?
    assert u.save
  end
  
  test "when create a user active should be true" do 
    u = User.new
    u.email = "email@email.com"
    u.password = "email"
    
    assert u.valid?
    assert u.save
    assert_equal 1, u.active
  end
  
  test "should validate email is presence before save" do 
    u = User.new
    u.password = "secret"
    
    assert !u.valid?
    assert !u.save
    assert u.errors[:email].any?
  end
  
  test "should validate email is valid before save" do 
    u = User.new
    u.password = "secret"
    u.email = "emailnotvalid"
    
    assert !u.valid?
    assert !u.save
    assert u.errors[:email].any?
  end
  
  test "should validate email is uniquesses before save" do 
    u = User.new
    u.email = "email@email.com"
    u.password = "email"

    assert u.valid?
    assert u.save
    
    u2 = User.new
    u2.email = "email@email.com"
    u2.password = "email2"
    
    assert !u2.valid?
    assert !u2.save
    assert u2.errors[:email].any?
  end
  
  test "should validate password is presence before save" do 
    u = User.new
    u.email = "email@email.com"
    
    assert !u.valid?
    assert !u.save
    assert u.errors[:password].any?
  end
  
  test "should validate password is valid before save" do 
    u = User.new
    u.email = "email@email.com"
    u.password = "1"
    
    assert !u.valid?
    assert !u.save
    assert u.errors[:password].any?
  end
  
  test "should encrypt a password before and save a hashed_password" do
    u = User.new
    u.email = "email@email.com"
    u.password = 'user'
    
    assert u.save
    assert_equal "12dea96fec20593566ab75692c9949596833adc9", u.hashed_password
  end
  
  test "should be authenticate user by email and password" do 
    u = User.new
    u.email = "email@email.com"
    u.password = 'user'
    
    assert u.save
    
    u2 = User.authenticate "email@email.com", "user"
    assert_equal u.id, u2.id
  end
  
end
