class TaskTypesController < ApplicationController
  
  before_filter :authenticate, :load_project
  
  # GET /task_types
  # GET /task_types.json
  def index
    @task_types = @project.task_types

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @task_types }
    end
  end

  # GET /task_types/1
  # GET /task_types/1.json
  def show
    @task_type = @project.task_types.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @task_type }
    end
  end

  # GET /task_types/new
  # GET /task_types/new.json
  def new
    @task_type = @project.task_types.new

    respond_to do |format|
      format.js
    end
  end

  # GET /task_types/1/edit
  def edit
    @task_type = TaskType.find(params[:id])
  end

  # POST /task_types
  # POST /task_types.json
  def create
    @task_type = @project.task_types.new(params[:task_type])

    respond_to do |format|
      if @task_type.save
        format.js {render 'projects/create_task_type'}
        format.html { redirect_to project_path(@project), :notice => 'Task type was successfully created.' }
      else
        format.html { render :action => "new" }
        format.js {render 'create_fail'}
      end
    end
  end

  # PUT /task_types/1
  # PUT /task_types/1.json
  def update
    @task_type = @project.task_types.find(params[:id])

    respond_to do |format|
      if @task_type.update_attributes(params[:task_type])
        format.html { redirect_to @task_type, :notice => 'Task type was successfully updated.' }
        format.js {render 'projects/create_task_type'}
      else
        format.js {render 'create_fail'}
        format.json { render :json => @task_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /task_types/1
  # DELETE /task_types/1.json
  def destroy
    @task_type = @project.task_types.find(params[:id])
    @task_type.update_attributes(:active => 0)

    respond_to do |format|
      format.html { redirect_to task_types_url }
      format.json { head :no_content }
    end
  end
  
  private
   def load_project
     begin
       @project = current_user.projects.find(params[:project_id])
     rescue ActiveRecord::RecordNotFound
       logger.info { "User #{current_user.email} try access a task_type to project #{params[:project_id]} without permission" }
       respond_to do |format|
          format.html {redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")}
          format.js {render :js => "location.href='#{projects_path}'"}
       end
     end
   end
   
end
