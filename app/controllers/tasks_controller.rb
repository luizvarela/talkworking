class TasksController < ApplicationController
  
  before_filter :authenticate, :load_task_list
  
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @task_list.tasks

    respond_to do |format|
      format.html
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    
    @task = @task_list.tasks.new(params[:task])
    @task.column = @project.columns.order("\"order\"").first
    
    respond_to do |format|
      if @task.save
        
        @task.historical.create(:project_id => @task_list.project.id, :user_id => current_user.id, 
        :title => t("historicals.titles.task.create"),  :description => @task.to_json)
        
        format.js {render 'projects/create_task'}
        format.html { redirect_to project_task_list_tasks_path(@project, @task_list, @task), :notice => 'Task was successfully created.' }
      else
        format.html { render :action => "new" }
        format.js {render 'create_fail'}
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])
    
    respond_to do |format|
      if @task.update_attributes(params[:task])
        
        @task.historical.create(:project_id => @task_list.project.id, :user_id => current_user.id, 
          :title => t("historicals.titles.task.update", :title => @task.title),  :description => @task.to_json)
        
        format.html { redirect_to @task, :notice => 'Task was successfully updated.' }
        format.js {render 'projects/create_task'}
      else
        format.html { render :action => "edit" }
         format.js {render 'create_fail'}
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    begin
      @task = @task_list.tasks.find(params[:id])
      
       @task.historical.create(:project_id => @task_list.project.id, :user_id => current_user.id, 
        :title => t("historicals.titles.task.delete"),  :description => @task.to_json)
        
      @task.destroy
      respond_to do |format|
        format.js {render 'projects/create_task'}
      end
    rescue
      logger.info "User #{current_user.email} try delete task #{params[:id]} without permission"
    end  
  end
  
  private 
  
  def load_task_list
    begin
      @project = Project.find(params[:project_id])
      @task_list = @project.task_lists.find(params[:task_list_id])
      @project.users.find(current_user.id)
      
    rescue ActiveRecord::RecordNotFound
      logger.info { "User #{current_user.email} try access tasks of task_list #{params[:task_list_id]} without permission" }
      redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")
    end
  end
  
end
