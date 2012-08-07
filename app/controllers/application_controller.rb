class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?, :get_tasks_for_projects, :get_tasks_completed_for_project, :get_percent_tasks_completed_for_project

  protected

  def current_user
  	return unless session[:user_id]
  	@current_user ||= User.find_by_id(session[:user_id])
  end

  def authenticate
  	logged_in? ? true : access_denied
  end

  def logged_in?
  	current_user.is_a? User
  end

  def access_denied
    respond_to do |format|
  	 format.html{ redirect_to login_path, :notice => "Please log in to continue" and return false}
     format.js {render :js => "location.href='#{login_path}'" and return false}
    end
  end
  
  def get_tasks_for_projects(projects)
    @tasks = []
      
    projects.task_lists.each do |tasklist|
      @tasks.concat tasklist.tasks
    end
    @tasks
  end

  def get_tasks_completed_for_project(project, task_list = nil)
    return project.columns.order('"order"').last.tasks if task_list.nil?

    tasks = []
    task_list.tasks.each do |task|
      tasks << task if task.column.id == project.columns.order('"order"').last.id
    end 
    tasks
  end

  def get_percent_tasks_completed_for_project(project, task_list = nil)
    return (get_tasks_completed_for_project(project).count.to_f / get_tasks_for_projects(project).count) * 100 if task_list.nil?
    
    return 0 if get_tasks_completed_for_project(@project, task_list).count == 0
    
    (get_tasks_completed_for_project(@project, task_list).count.to_f / task_list.tasks.count.to_f) * 100
  end

end
