require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
  end

  test "should get create a session when user credentials is correctly" do
    User.create(:email => 'user@user.com', :password => 'user')
    
    get :create, {:email => 'user@user.com', :password => 'user'}

    assert_response :redirect
    assert_redirected_to root_path
  end
  
  test "should get create a session and show message when credentials is not correctly" do 
    get :create, {:email => 'user1@user1.com', :password => 'user'}

    assert_template :new
    assert_select '#info-message-span', I18n.t('sessions.messages.login_error')
  end
  
  test "should get destroy" do
    get :destroy
    assert_response :redirect
    assert_nil session[:user_id]
    assert_redirected_to login_path
  end

end
