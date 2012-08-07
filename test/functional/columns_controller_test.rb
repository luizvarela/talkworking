require 'test_helper'

class ColumnsControllerTest < ActionController::TestCase
  setup do
    @column = columns(:todo)
    projects(:talkworking).columns << columns(:todo)
    task_lists(:buy_bread).tasks << tasks(:one)
    projects(:talkworking).task_lists << task_lists(:buy_bread)
    users(:leonardo).projects << projects(:talkworking)
  end

  test "should get index and show columns to project associated" do
    login_as :leonardo
    
    get :index, :project_id => projects(:talkworking).id
    
    assert_response :success
    assert_not_nil assigns(:columns)
  end

  test "should not get index and redirect to projects_path if user is not associated a project" do 
    login_as :leonardo
    
    get :index, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not get index and redirect to login_path if user is not logged" do 
    get :index, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  

  test "should get new column with ajax" do
    login_as :leonardo
    
    xhr :get, :new, :project_id => projects(:talkworking).id  
    
    assert_response :success
    assert_template :new
    assert_not_nil assigns(:column).project
  end

  test "should not get new column and redirect to project_path if user is not associated a project" do 
    login_as :leonardo
    
    get :new, :project_id => projects(:tasks).id  
    
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not get column and redirect to login_path if user not logged" do
    get :new, :project_id => projects(:talkworking)
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should create column with ajax" do
    login_as :leonardo 
    
    assert_difference('Column.count') do
      xhr :post, :create, :column => { :color => "#CCCCCC", :order => @column.order, :project_id => projects(:talkworking).id, :title => @column.title }, 
        :project_id => projects(:talkworking).id
    end

    assert_response :success
  end
  
  test "should not create a column and redirect to projects_path if user is not associated a project" do 
    login_as :leonardo 
    
    post :create, :column => { :color => @column.color, :order => @column.order, :project_id => projects(:talkworking).id, :title => @column.title }, 
      :project_id => projects(:tasks).id
      
    assert_nil assigns(:column)
    assert_response :redirect
    assert_redirected_to projects_path
    assert_equal I18n.t("system.messages.access_denied"), flash[:alert]
  end
  
  test "should not create a column and redirect to login_path if user is not logged" do 
    post :create, :column => { :color => @column.color, :order => @column.order, :project_id => projects(:talkworking).id, :title => @column.title }, 
      :project_id => projects(:talkworking).id
      
    assert_response :redirect
    assert_redirected_to login_path
  end
  
  test "should get edit column" do
    login_as :leonardo
    
    xhr :get, :edit, :id => @column, :project_id => projects(:talkworking).id
    
    assert_response :success
    assert_template :edit
  end
  
  test "should not get edit column and redirect to projects_path if current user is not associated a project" do 
    login_as :leonardo
    
    get :edit, :id => @column, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to projects_path
  end
  
  test "should not get edit column and redirect to login_path if user is not logged" do 
    get :edit, :id => @column, :project_id => projects(:tasks).id
    
    assert_response :redirect
    assert_redirected_to login_path
  end
  #TEST FOR UPDATE AN DESTROY AND SHOW HER
  
  test "should order columns with ajax" do 
    login_as :leonardo
    projects(:talkworking).columns << columns(:test)

    xhr :get, :sortcolumn, :project_id => projects(:talkworking), :columns => [columns(:todo).id, columns(:test).id]

    assert_response :success
    assert_template :sortcolumn
  end

  #test "should reverttask width ajax" do 
  #  login_as :leonardo
  #  projects(:talkworking).columns << columns(:test)

  #  xhr :get, :reverttask, :project_id => projects(:talkworking).id, :task_id => tasks(:one).id

  #  assert_response :success
  #  assert_template :reverttask
  #end

end
