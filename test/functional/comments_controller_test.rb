require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  setup do
    @comment = comments(:one)
  end

  test "should get index" do
    login_as :leonardo
    
    get :index
    assert_response :success
    assert_not_nil assigns(:comments)
  end

  test "should create comment" do
    login_as :leonardo
    
    assert_difference('Comment.count') do
      post :create, comment: { comentavel_id: tasks(:one).id, comentavel_type: "Task", content: tasks(:one).to_json, title: "Create a new task" }
    end

    assert_redirected_to comment_path(assigns(:comment))
  end

  test "should show comment" do
    login_as :leonardo
    
    get :show, id: @comment
    assert_response :success
  end

  test "should destroy comment" do
    login_as :leonardo
    
    assert_difference('Comment.count', -1) do
      delete :destroy, id: @comment
    end

    assert_redirected_to comments_path
  end
end
