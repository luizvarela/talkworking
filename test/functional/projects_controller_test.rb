require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:talkworking)
    users(:leonardo).projects << @project
    projects(:talkworking).task_lists << task_lists(:buy_bread)
    projects(:talkworking).columns << columns(:todo)
  end

  test "should get index and show projects to user is associated" do
    login_as :leonardo
    
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
    assert_equal 1, assigns(:projects).size
    assert_select '.thumbnail', 2
    assert_select '#user-count-div', '1'
    assert_select '#task-lists-count-div', '1'
#    assert_select '#column-count-div', '1'
  end
  
  test "should authenticate user when get index" do 
    get :index
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should get new" do
    login_as :leonardo
    
    get :new
    assert_template :new
    assert_response :success
  end
  
  test "should authenticate user when get new" do 
    get :new
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should create project associated to current user" do
    login_as :leonardo
    
    assert_difference('Project.count') do
      post :create, :project => { :description => @project.description, :title => @project.title }, :users=>["", "", ""]
    end
    
    assert_equal 1, assigns(:project).users.size
    assert_equal 3, assigns(:project).columns.count
    assert_equal 2, assigns(:project).task_types.count
    assert_equal users(:leonardo).id, assigns(:project).users.first.id
    assert_redirected_to project_path(assigns(:project))
  end
  
  test "should validate a title is presence before create project" do 
    login_as :leonardo
    
    post :create, :project => { :description => @project.description, :title => ""}, :users=>["", "", ""]
    
    assert_response :success
    assert_template :new
#    assert_select '#project-errors-message', "Title can't be blank"
  end
  
  test "should create project associated to current user and two more where one already exists" do 
    login_as :leonardo
    
    assert User.create(:email => 'teste@teste.com', :password => '123456')
    
    assert_difference('Project.count') do
      post :create, :project => { :description => @project.description, :title => @project.title }, :users=>["teste@teste.com", "teste2@teste2.com", ""]
    end
    
    assert_equal 3, assigns(:project).users.size
    assert_not_nil assigns(:project).users.find_by_email 'teste@teste.com'
    assert_not_nil assigns(:project).users.find_by_email 'teste2@teste2.com'
    assert_not_nil assigns(:project).users.find_by_email 'leo@leo.com'
    assert_redirected_to project_path(assigns(:project))
  end
  
  test "should authenticate user when try create a project" do 
     post :create, :project => { :description => @project.description, :title => @project.title }
     
     assert_response :redirect
     assert_redirected_to login_path
  end
  
  test "should show projects associated whit current user" do
    login_as :leonardo
    users(:leonardo).projects << projects(:talkworking)
    
    get :show, :id => projects(:talkworking).id
    
    assert_response :success
    assert_template :show
  end
  
  test "should redirect to projects list if current user not associated with project when show project" do 
    login_as :leonardo
    
    get :show, :id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should redirect to login if user not authenticated when request show project" do     
    users(:leonardo).projects << projects(:talkworking)

    get :show, :id => projects(:talkworking).id

    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should get edit and load project to current user" do
    login_as :leonardo
    
    users(:leonardo).projects << projects(:talkworking)
    
    get :edit, :id => @project
    assert_response :success
    assert_template :edit
  end
  
  test "should get edit and redirect to project list if current user not associated with project" do 
    login_as :leonardo
    
    get :edit, :id => projects(:tasks).id
    
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
    
  end
  
  test "should get edit and redirect to login path if user is not logged" do 
    get :edit, :id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should update project if current user is associated a project with ajax" do
    users(:leonardo).projects << projects(:talkworking)
    login_as :leonardo
    
    xhr :put, :update, :id => @project, :project => { :description => 'update description', :title => @project.title }
    
    assert_response :success
    assert_template :update
  end
  
  test "should update project and show a error messages if model contains any error" do
    users(:leonardo).projects << projects(:talkworking)
    login_as :leonardo
    
    xhr :put, :update, :id => @project, :project => { :description => 'update description', :title => '' }
    
    assert_response :success
    assert_template 'update_project_fail'
    #assert_select '#error-project-span', "Title can't be blank"
  end
=begin  
  test "should destroy project if user is associated a project" do
    users(:leonardo).projects << projects(:talkworking)
    login_as :leonardo
    
    count = Project.count
    
    delete :destroy, :id => @project
    
    assert_equal 0, Project.find(@project.id).active
    assert_equal (count - 1), Project.count
    assert_redirected_to projects_path
  end
=end  
  test "should destroy project and if user is not associated a project redirect to projects_path" do
    users(:leonardo).projects << projects(:talkworking)
    login_as :leonardo
    
    delete :destroy, :id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should destroy project and if user is not logged redirect to login_path" do 
    delete :destroy, :id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should invite friends to project" do
    login_as :leonardo

    post :invite_friend, :id => projects(:talkworking), :users=>["teste@teste.com.br", users(:jef).email, users(:leonardo).email]

    assert_response :redirect
    assert_redirected_to projects(:talkworking)
    assert_equal 3, User.count 
    assert_equal 3, projects(:talkworking).users.count
  end
  
  test "should get invite a friend and redirect to projects_path if user not associated a project" do 
    login_as :leonardo

    post :invite_friend, :id => projects(:tasks), :users=>["teste@teste.com.br", users(:jef).email, users(:leonardo).email]

    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal 2, User.count 
    assert_equal 1, projects(:talkworking).users.count
  end

  test "should get invite a friend and redirect to login_path if user not logged" do
    post :invite_friend, :id => projects(:tasks), :users=>["teste@teste.com.br", users(:jef).email, users(:leonardo).email]

    assert_response :redirect
    assert_redirected_to login_path
    assert_equal 2, User.count 
    assert_equal 1, projects(:talkworking).users.count
  end

end
