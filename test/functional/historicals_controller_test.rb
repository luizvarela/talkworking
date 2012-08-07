require 'test_helper'

class HistoricalsControllerTest < ActionController::TestCase
  setup do
    @historical = historicals(:one)
    users(:leonardo).projects << projects(:talkworking)
  end

  test "should get index" do
    login_as :leonardo
    
    get :index, :project_id => projects(:talkworking).id
    assert_response :success
    assert_not_nil assigns(:historicals)
  end

end
