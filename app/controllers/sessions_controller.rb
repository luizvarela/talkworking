class SessionsController < ApplicationController
  
  def new
    @user = User.new
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
    	session[:user_id] = user.id
			redirect_to root_path, :notice =>  I18n.t('sessions.messages.login_successfully')
		else
			flash.now[:alert] = I18n.t('sessions.messages.login_error')
			render :action => :new
		end
  end

  def destroy
    reset_session
		redirect_to login_path, :notice => I18n.t('sessions.messages.logout_successfully')
  end
end
