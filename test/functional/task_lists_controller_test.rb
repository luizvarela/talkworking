require 'test_helper'

class TaskListsControllerTest < ActionController::TestCase
  setup do
    @task_list = task_lists(:buy_bread)
    projects(:talkworking).task_lists << task_lists(:buy_bread)
    projects(:talkworking).columns << columns(:test)
    projects(:talkworking).columns << columns(:todo)
    users(:leonardo).projects << projects(:talkworking)
    task_lists(:buy_bread).tasks << tasks(:one)
    task_lists(:buy_bread).tasks << tasks(:two)
    tasks(:one).column = columns(:todo)
    tasks(:two).column = columns(:test)
  end

  test "should get index a tasks list of project if user associated a project" do
    login_as :leonardo
    
    get :index, :project_id => projects(:talkworking).id
    
    assert_response :success
    assert_not_nil assigns(:task_lists)
  end
  
  test "should not get index a tasks list of project and if user not associated a project redirect to projects_path" do
    login_as :leonardo
    
    get :index, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not get index and redirect to login_path if user is not logged" do
    get :index, :project_id => projects(:talkworking).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end
   
  test "should get new task list of project with ajax" do
    login_as :leonardo

    xhr :get, :new, :project_id => projects(:talkworking).id

    assert_response :success
    assert_template :new
    #assert_select '#new_task_list', 1
  end

  test "shold not get new task list if user is not associated a project redirect to projects_path with ajax" do 
    login_as :leonardo
    
    xhr :get, :new, :project_id => projects(:tasks).id
    
    assert_response :success
    response.content_type == Mime::JS
  end

  test "should not get new task list if user is not associated a project redirect to projects_path " do 
    login_as :leonardo
    
    get :new, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not get new task list and redirect a login_path if user is not logged with ajax" do 
    xhr :get, :new, :project_id => projects(:tasks).id
    
    assert_response :success
    response.content_type == Mime::JS
    assert_nil assigns(:project)
  end

  test "should not get new task list and redirect a login_path if user is not logged" do 
    get :new, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should create task_list associated a one project with ajax" do
    login_as :leonardo
    
    assert_difference('TaskList.count') do
      xhr :post, :create, :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }, 
        :project_id => projects(:talkworking).id
    end
    
    assert_response :success
    response.content_type == Mime::JS
    assert_equal assigns(:task_list).project.id, projects(:talkworking).id
  end

  test "should create task_list associated a one project" do
    login_as :leonardo
    
    assert_difference('TaskList.count') do
      post :create, :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }, 
        :project_id => projects(:talkworking).id
    end
    
    assert_response :redirect
    assert_redirected_to project_path assigns(:project)
    assert_equal assigns(:task_list).project.id, projects(:talkworking).id
    assert_equal flash[:notice], 'Task list was successfully created.'
  end
  
  test "should not create task_list associated a one project if project associated a current user with ajax" do 
    login_as :leonardo
    
    xhr :post, :create, :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }, 
      :project_id => projects(:tasks).id
    
    assert_response :success
    response.content_type == Mime::JS
    assert_nil assigns(:task_list)
  end

  test "should not create task_list associated a one project if project associated a current user" do 
    login_as :leonardo
    
    post :create, :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }, 
      :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_nil assigns(:task_list)
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not create task_list associated a one project if user is logged with ajax" do 
    xhr :post, :create, :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }, 
      :project_id => projects(:tasks).id
      
    assert_response :success
    response.content_type == Mime::JS
    assert_nil assigns(:project)
  end

  test "should not create task_list associated a one project if user is logged" do 
    post :create, :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }, 
      :project_id => projects(:tasks).id
      
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should get edit task list associated a project with ajax" do
    login_as :leonardo
    
    xhr :get, :edit, :id => @task_list, :project_id => projects(:talkworking).id
    
    assert_response :success
    assert_template :edit
  end
  
  test "should not get edit task list and redirect to project_path if task is not associated a project" do 
    login_as :leonardo
    
    get :edit, :id => @task_list, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
  end
  
  test "should not get edit task list and redirect to login_path if user is not logged" do 
    get :edit, :id => @task_list, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should update task_list associated a one project" do
    login_as :leonardo
    
    put :update, :id => @task_list, :project_id => projects(:talkworking).id,
      :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }
    
    assert_response :redirect
    assert_equal 'Task list was successfully updated.', flash[:notice]
    assert_redirected_to project_task_list_path(assigns(:project), assigns(:task_list))
  end
  
  test "should not update task and redirect to projects if user is not associated a project" do 
    login_as :leonardo
    
    put :update, :id => @task_list, :project_id => projects(:tasks).id,
      :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }
      
    assert_response :redirect
    assert_redirected_to projects_path
  end
  
  test "should not update task and redirect project_path if task is not associated a project" do 
    login_as:leonardo
    
     put :update, :id => task_lists(:testing_project), :project_id => projects(:talkworking).id,
        :task_list => { :description => @task_list.description, :end_date => @task_list.end_date, :name => @task_list.name }
        
    assert_response :redirect
    assert_redirected_to project_path(assigns(:project))
  end
=begin
  test "should destroy task_list associated a project" do
    login_as :leonardo
    
    assert_difference('TaskList.count', -1) do
      delete :destroy, :id => @task_list, :project_id => projects(:talkworking).id
    end

    assert_response :redirect
    assert_redirected_to project_path(assigns(:project))
  end
=end
  test "should not destroy task list and redirect to project_path if project is not associated a current user" do
    login_as :leonardo
    
    delete :destroy, :id => @task_list, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not destroy a task list and redirect to login_path if user is not logged" do 
    delete :destroy, :id => @task_list, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should show task_list" do
    login_as :leonardo

    get :show, :id => task_lists(:buy_bread), :project_id => projects(:talkworking)

    assert_response :success
    assert_template :show
    assert_select '#tasks-completed-count', '0'
    assert_select '#tasks-total-count', '0'
    assert_select '#tasks-completed-percent', '0%'
  end

  test "should show task_list after create a new task list" do 
    login_as :leonardo

    newTask = TaskList.create(:name => "Task list of test", :end_date => Time.now)
    projects(:talkworking).task_lists << newTask

    get :show, :id => newTask, :project_id => projects(:talkworking)

    assert_response :success
    assert_template :show
    assert_select '#tasks-completed-count', '0'
    assert_select '.bar', '0%'
  end

end
