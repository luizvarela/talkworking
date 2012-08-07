require 'test_helper'

class ProjectStoriesTest < ActionDispatch::IntegrationTest

  fixtures :all

  test "should execute a project stories" do
  	#get login page
  	get login_path
  	assert_response :success
  	assert_template :new

  	#execute login
  	post session_path, :email => 'jef@jef.com', :password => 'guest'
  	assert_response :redirect
  	assert_redirected_to root_path
  	assert session[:user_id]

  	#list projects
  	follow_redirect!
  	assert_response :success
  	assert_template :index
  	#assert_select '.span2', 2
  	#assert_select '.span3', 0

  	#new project
  	get new_project_path
  	assert_response :success
  	assert_template :new

  	#create project with errors
  	post projects_path, :project => { :description => nil, :title => nil }, :users=>["", "", ""]
  	assert_response :success
  	assert_template :new
  	
  	#create project with 1 user
  	post projects_path, :project => { :description => nil, :title => 'My first project' }, :users=>["leonardo.prg@gmail.com", "", ""]
  	assert_response :redirect
  	assert_redirected_to project_path(Project.last)

  	#show project
  	follow_redirect!
  	assert_response :success
  	assert_template :show
  	assert_select '.empty-project', 1

  	#new task list
  	xhr :get, new_project_task_list_path(Project.last)
  	assert_response :success
  	assert_template :new

  	#create task list
  	#xhr :post, 	project_task_lists_path, :task_list => { :description => nil, :end_date => Time.now.to_date, :name => 'Sprint 1' },
  	# :project_id => Project.last.id

  	#assert_select '#user-count-div', '1'
  	#assert_select '#task-lists-count-div', '0'
  	#assert_select '#column-count-div', '0'

  end

end
