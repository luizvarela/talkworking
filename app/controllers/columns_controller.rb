class ColumnsController < ApplicationController
  
  before_filter :authenticate, :load_project
  
  # GET /columns
  # GET /columns.json
  def index
    @columns = @project.columns.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @columns }
    end
  end

  # GET /columns/1
  # GET /columns/1.json
  def show
    @column = Column.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @column }
    end
  end

  # GET /columns/new
  # GET /columns/new.json
  def new
    @column = @project.columns.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /columns/1/edit
  def edit
    @column = Column.find(params[:id])
  end

  # POST /columns
  # POST /columns.json
  def create    
    @column = @project.columns.new(params[:column])
    @column.order = @project.columns.count + 1

    respond_to do |format|
      if @column.save
        format.js {render 'projects/create_column'}
      else
        format.js { render 'create_fail' }
      end
    end
  end

  # PUT /columns/1
  # PUT /columns/1.json
  def update
    begin 
      @column = @project.columns.find(params[:id])

      respond_to do |format|
        if @column.update_attributes(params[:column])
          format.js {render 'projects/create_column'}
          format.html { redirect_to @project, :notice => 'Column was successfully updated.' }
        else
          format.js {render :create_fail}
          format.html { render :action => "edit" }
        end
      end
    rescue ActiveRecord::RecordNotFound
      logger.info { "user #{current_user.email} try access a column #{params[:id]}" }
      redirect_to projects_path, :notice => I18n.t("system.messages.access_denied")
    end
  end

  # DELETE /columns/1
  # DELETE /columns/1.json
  def destroy
    @column = @project.columns.find(params[:id])
    tasks = @column.tasks
    if @project.columns.count == 0
      redirect_to project_path, :alert => I18n.t("system.messages.delete_columns.error_no_columns")
    end
    @project.columns.where("id != #{@column.id}").first.tasks << tasks if !tasks.empty?
    
    @column.update_attributes(:active => 0)

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js {render 'projects/create_column'}
    end
  end
  
  def addtask
    respond_to do |format|
      begin
        @column = @project.columns.find(params[:column_id])
        @task = Task.find params[:task_id]
        @task_list = @task.task_list
        @column.tasks << @task
        
         @task.historical.create(:project_id => @task.task_list.project.id, :user_id => current_user.id, 
          :title => t("historicals.titles.task.update_column"),  :description => @task.to_json)
        
        format.js
      rescue
        logger.info { "User #{current_user.email} try add task #{params[:task_id]} to column #{params[:column_id]} with #{params[:project_id]} whitout permission" }
      end
    end
  end
  
  def reverttask
     respond_to do |format|
      begin
        @task = Task.find params[:task_id]
        @column = @task.column.id == @project.columns.order('"order"').last.id ? @project.columns.order('"order"').first :  @project.columns.order('"order"').last
        @column.tasks << @task
        
        format.js {render 'reverttask'}
      rescue
        logger.info { "User #{current_user.email} try revert task #{params[:task_id]}  with #{params[:project_id]} whitout permission" }
      end
    end
  end

  def sortcolumn
    respond_to do |format|
      begin
        params[:columns].each_with_index do |id, index|
           @column = @project.columns.find(id)
           @column.update_attributes :order => index
        end
        format.js
      rescue
        logger.info { "User #{current_user.email} try add task #{params[:task_id]} to column #{params[:column_id]} with #{params[:project_id]} whitout permission" }
        format.js {render 'sortcolumn_fail'}
      end
    end
  end

  private
    def load_project
      begin 
        @project = current_user.projects.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        logger.info { "User #{current_user.email} try access a columns to project #{params[:project_id]} whitout permission" }
        redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")
      end
    end
    
end
