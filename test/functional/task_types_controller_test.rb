require 'test_helper'

class TaskTypesControllerTest < ActionController::TestCase
  setup do
    @task_type = task_types(:one)
    @task_type.project = projects(:talkworking)
    projects(:talkworking).users << users(:leonardo)
  end

  test "should get index" do
    login_as :leonardo
    
    get :index, :project_id => projects(:talkworking)
    
    assert_response :success
    assert_not_nil assigns(:task_types)
  end
  
  test "should not get index and redirect to projects_path if user is not associated" do 
    login_as :leonardo
    
    get :index, :project_id => projects(:tasks)
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not get index and redirect to login_path if user is not logged" do 
    get :index, :project_id => projects(:tasks)
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should get new with ajax" do
    login_as :leonardo
    
    xhr :get, :new, :project_id => projects(:talkworking).id
    
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:task_type).project
  end
  
  test "should not get new and redirect to projects_path if project is not associated a current_user with ajax" do 
    login_as :leonardo
    
    xhr :get, :new, :project_id => projects(:tasks).id
    
    assert_response :success
    response.content_type == Mime::JS
    assert_nil assigns(:task_type)
  end 

  test "should not get new and redirect to projects_path if project is not associated a current_user" do 
    login_as :leonardo
    
    get :new, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not get new and redirect to login_path if user is not logged with ajax" do 
    xhr :get, :new, :project_id => projects(:tasks).id
    
    assert_response :success
    response.content_type == Mime::JS
    assert_nil assigns(:project)
  end


  test "should not get new and redirect to login_path if user is not logged" do 
    get :new, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should create task_type with ajax" do
    login_as :leonardo
    
    assert_difference('TaskType.count') do
      xhr :post, :create, :task_type => { :color => "#FFFFFF", :project_id => @task_type.project_id, :title => @task_type.title },
        :project_id => projects(:talkworking)
    end
    
    assert_response :success
    response.content_type == Mime::JS
    assert_not_nil assigns(:task_type)
  end

  test "should create task_type" do
    login_as :leonardo
    
    assert_difference('TaskType.count') do
      post :create, :task_type => { :color => "#FFFFFF", :project_id => @task_type.project_id, :title => @task_type.title },
        :project_id => projects(:talkworking)
    end
    
    assert_response :redirect
    assert_redirected_to project_path(assigns(:project))
  end
  
  test "should not create task type and redirect to projects_path if user is not associated a project with ajax" do 
    login_as :leonardo
    
    xhr :post, :create, :task_type => { :color => "#FFFFFF", :project_id => @task_type.project_id, :title => @task_type.title },
      :project_id => projects(:tasks)
      
   assert_response :success
   response.content_type == Mime::JS
   assert_nil assigns(:task_type)
  end

  test "should not create task type and redirect to projects_path if user is not associated a project" do 
    login_as :leonardo
    
    post :create, :task_type => { :color => "#FFFFFF", :project_id => @task_type.project_id, :title => @task_type.title },
      :project_id => projects(:tasks)
      
   assert_response :redirect
   assert_redirected_to projects_path
   assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not create task type and redirect to login_path if user is not logged with ajax" do 
    xhr :post, :create, :task_type => { :color => "#FFFFFF", :project_id => @task_type.project_id, :title => @task_type.title },
      :project_id => projects(:tasks)
      
    assert_response :success
    response.content_type == Mime::JS
  end

  test "should not create task type and redirect to login_path if user is not logged" do 
    post :create, :task_type => { :color => "#FFFFFF", :project_id => @task_type.project_id, :title => @task_type.title },
      :project_id => projects(:tasks)
      
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should get edit" do
    login_as :leonardo
    
    get :edit, :id => @task_type, :project_id => projects(:talkworking)
    
    assert_response :success
    assert_template :edit
   end
   
   test "should not get edit and redirect to projects_path if user is not associated a project" do 
     login_as :leonardo

     get :edit, :id => @task_type, :project_id => projects(:tasks)

     assert_response :redirect
     assert_redirected_to projects_path
     assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
   end
   
   test "should not get edit and redirect to login_path if user is not logged" do 
     get :edit, :id => @task_type, :project_id => projects(:tasks)

     assert_response :redirect
     assert_redirected_to login_path
   end

end
