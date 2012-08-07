require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
    task_lists(:buy_bread).tasks << @task
    projects(:talkworking).task_lists << task_lists(:buy_bread)
    projects(:talkworking).columns << columns(:todo)
    users(:leonardo).projects << projects(:talkworking)
  end

  test "should get index" do
    login_as :leonardo
    
    get :index, :task_list_id => task_lists(:buy_bread), :project_id => projects(:talkworking)
    
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:tasks)
  end

  test "should not get index and redirect to projects_path if project is not associated" do 
    login_as :leonardo
    
    get :index, :task_list_id => task_lists(:buy_bread), :project_id => projects(:tasks)
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not get index and redirect to projects_path if task_lists is not associated" do 
    login_as :leonardo
    
    get :index, :task_list_id => task_lists(:testing_project), :project_id => projects(:talkworking)
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not get index and redirect to login_path if user is not logged" do 
    get :index, :task_list_id => task_lists(:testing_project), :project_id => projects(:talkworking)
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should get new with ajax" do
    login_as :leonardo
    
    xhr :get, :new, :task_list_id => task_lists(:buy_bread), :project_id => projects(:talkworking)
    
    assert_response :success
    assert_template :new
  end

  test "should create task" do
    login_as :leonardo
    
    assert_difference('Task.count') do
      post :create,:task_list_id => task_lists(:buy_bread), :project_id => projects(:talkworking),
        :task => { :body => @task.body, :end => Time.now.to_date, :task_list_id => @task.task_list_id, :title => @task.title, :user_id => @task.user_id, :task_type_id => task_types(:one) }
    end
    
    #assert_not_nil assigns(:task).column
    assert_response :redirect
    assert_redirected_to project_task_list_tasks_path(assigns(:project), assigns(:task_list), assigns(:task))
  end
  
  test "should not create task and redirect to projects_path if user and not associated" do 
     login_as :leonardo

     post :create,:task_list_id => task_lists(:buy_bread), :project_id => projects(:tasks),
          :task => { :body => @task.body, :end => Time.now.to_date, :task_list_id => @task.task_list_id, :title => @task.title, :user_id => @task.user_id }
     
      assert_response :redirect
      assert_redirected_to projects_path
  end
  
  test "should not create task and redirect to projects_path if task_list not assocciated a user" do 
    login_as :leonardo

     post :create,:task_list_id => task_lists(:testing_project), :project_id => projects(:talkworking),
          :task => { :body => @task.body, :end => Time.now.to_date, :task_list_id => @task.task_list_id, :title => @task.title, :user_id => @task.user_id }
     
     assert_response :redirect
     assert_redirected_to projects_path
  end
  
end
