class HistoricalsController < ApplicationController
  
  before_filter :authenticate
  before_filter :load_project, :except => [:index_to_projects]
  respond_to :html, :json, :js
  
  # GET /historicals
  # GET /historicals.json
  def index
    @historicals = @project.historical

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @historicals }
    end
  end
  
  def index_to_projects
    @projects = current_user.projects
  end
  
  # GET /historicals/1
  # GET /historicals/1.json
  def show
    @historical = Historical.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @historical }
    end
  end

  # GET /historicals/new
  # GET /historicals/new.json
  def new
    @historical = Historical.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @historical }
    end
  end

  # GET /historicals/1/edit
  def edit
    @historical = Historical.find(params[:id])
  end

  # POST /historicals
  # POST /historicals.json
  def create
    @historical = Historical.new(params[:historical])

    respond_to do |format|
      if @historical.save
        format.html { redirect_to @historical, notice: 'Historical was successfully created.' }
        format.json { render json: @historical, status: :created, location: @historical }
      else
        format.html { render action: "new" }
        format.json { render json: @historical.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /historicals/1
  # PUT /historicals/1.json
  def update
    @historical = Historical.find(params[:id])

    respond_to do |format|
      if @historical.update_attributes(params[:historical])
        format.html { redirect_to @historical, notice: 'Historical was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @historical.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /historicals/1
  # DELETE /historicals/1.json
  def destroy
    @historical = Historical.find(params[:id])
    @historical.destroy

    respond_to do |format|
      format.html { redirect_to historicals_url }
      format.json { head :no_content }
    end
  end
  
  def load_project
    begin
      @project = current_user.projects.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      logger.info { "User #{current_user.email} try access  task_lists of project #{params[:project_id]} without permission" }
      redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")
    end
  end
  
end
