class ProjectsController < ApplicationController
  
  before_filter :authenticate
  respond_to :html, :js
  add_breadcrumb I18n.t("projects.breadcrumbs.index"), :root_path
  add_breadcrumb I18n.t("projects.breadcrumbs.show"), :project_path, :except => [:index, :new, :create]
 
  def index
    @projects = current_user.projects.all
  end

  def show
    begin
      @project = current_user.projects.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.info { "User #{current_user.email} try access project #{params[:id]} without permission" }
      redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")
    end
  end


  def new
    @project = current_user.projects.new
  end

 
  def edit
    begin
      @project = current_user.projects.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.info { "User #{current_user.email} try edit project #{params[:id]} without permission" }
      redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")
    end
  end

 
  def create
    @project = Project.new(params[:project])

    respond_to do |format|

      if @project.save
        
        @project.users << current_user
        @project.columns = Column.default
        @project.task_types = TaskType.default

        params[:users].each do |email|
          if !email.empty?
            user = User.find_by_email email
            if user.nil?
              if u = User.create(:email => email, :password => User.random_password)
                @project.users << u
                #Notifier.delay.invite_a_friend(u, u.password, current_user, @project)
                Notifier.invite_a_friend(u, u.password, current_user, @project).deliver
              end
            else
                if @project.users << user
                  #Notifier.delay.associated_a_project(user, current_user, @project)
                  Notifier.associated_a_project(user, current_user, @project).deliver
                end
            end
          end
        end

        format.html { redirect_to @project, :notice => 'Project was successfully created.' }
        format.json { render :json => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.json { render :json => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def update
    @project = current_user.projects.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.js
      else
        format.js {render 'update_project_fail'}
      end
    end
  end

 
  def destroy
    begin
      @project = current_user.projects.find(params[:id])
      
      @project.update_attributes(:active => 0)
      
      respond_to do |format|
        format.html { redirect_to projects_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::RecordNotFound
      logger.info { "User #{current_user.email} try delete project #{params[:id]} without permission" }
      redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")
    end
  end
  
  def kanban
    begin
      @project = current_user.projects.find(params[:id])

      @task_list = @project.task_lists.find(params[:task_list_id]) if !params[:task_list_id].nil? 
      @task_list = @project.task_lists.last if @task_list.nil?

      @user = @project.users.find(params[:user_id]) if !params[:user_id].nil?

      add_breadcrumb "#{I18n.t('projects.breadcrumbs.kanban')} (#{@task_list.name})", kanban_path(@project, @task_list) if !@task_list.nil?
    rescue ActiveRecord::RecordNotFound
      logger.info { "User #{current_user.email} try to access kanban to project #{params[:id]} without permission" }
      redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")
    end
  end

  def invite_friend
    begin
      @project = current_user.projects.find(params[:id])

      params[:users].each do |email|
          if !email.empty?
            user = User.find_by_email email
            if user.nil?
              if u = User.create(:email => email, :password => User.random_password)
                @project.users << u
                #Notifier.delay.invite_a_friend(u, u.password, current_user, @project)
                Notifier.invite_a_friend(u, u.password, current_user, @project).deliver
              end
            else
                if @project.users << user
                  #Notifier.delay.associated_a_project(user, current_user, @project)
                  Notifier.associated_a_project(user, current_user, @project).deliver
                end
            end
          end
        end
        redirect_to @project, :notice => I18n.t("projects.messages.invite_friend")
    rescue ActiveRecord::RecordNotFound
      logger.info { "User #{current_user.email} try to access invite_friend to project #{params[:id]} without permission" }
      redirect_to projects_path, :alert => I18n.t("system.messages.access_denied")
    end
  end


end
