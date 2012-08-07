class TaskListsController < ApplicationController
  
  before_filter :authenticate, :load_project
  respond_to :html, :json, :js
  
  # GET /task_lists
  # GET /task_lists.json
  def index
    @task_lists = @project.task_lists.all

    respond_with @task_lists
  end

  # GET /task_lists/1
  # GET /task_lists/1.json
  def show
    @task_list = TaskList.find(params[:id])
    add_breadcrumb I18n.t("tasklist.breadcrumbs.show"), project_task_list_path

    respond_with @task_lists
  end

  # GET /task_lists/new
  # GET /task_lists/new.json
  def new
    @task_list = @project.task_lists.new

    respond_with @task_lists
  end

  # GET /task_lists/1/edit
  def edit
    @task_list = TaskList.find(params[:id])
  end

  # POST /task_lists
  # POST /task_lists.json
  def create
    @task_list = @project.task_lists.new(params[:task_list])

    respond_to do |format|
      if @task_list.save
        format.js {render 'projects/create_task_list'}
        format.html { redirect_to project_path(@project), :notice => 'Task list was successfully created.' }
      else
        format.js {render :create_fail}
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /task_lists/1
  # PUT /task_lists/1.json
  def update
    begin
      @task_list = @project.task_lists.find(params[:id])

      respond_to do |format|
        if @task_list.update_attributes(params[:task_list])
          format.js {render 'projects/create_task_list'}
          format.html { redirect_to project_task_list_path(@project, @task_list), :notice => 'Task list was successfully updated.' }
        else
          format.js {render :create_fail}
          format.html { render :action => "edit" }
        end
      end
    rescue ActiveRecord::RecordNotFound
      logger.info { "User #{current_user.email} try update a task list #{params[:id]} without permission" }
      redirect_to project_path(@project)
    end
  end

  # DELETE /task_lists/1
  # DELETE /task_lists/1.json
  def destroy
    @task_list = TaskList.find(params[:id])
    @task_list.update_attributes(:active => 0)
    
    respond_to do |format|
      format.html { redirect_to project_path(@project) }
      format.json { head :no_content }
    end
  end
  
  private 
  
    def load_project
      begin
        @project = current_user.projects.find(params[:project_id])

        add_breadcrumb I18n.t("projects.breadcrumbs.index"), :root_path
        add_breadcrumb @project.title, project_path(@project)
        
      rescue ActiveRecord::RecordNotFound
        logger.info { "User #{current_user.email} try access  task_lists of project #{params[:project_id]} without permission" }
        respond_to do |format|
          format.html {redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")}
          format.js {render :js => "location.href='#{projects_path}'"}
        end
      end
    end
    
end
