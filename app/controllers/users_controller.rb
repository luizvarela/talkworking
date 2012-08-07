class UsersController < ApplicationController
  before_filter :authenticate, :except => [:create]

  def profile
  	@user = current_user
  end

  def invite
  end
  
  def create
    @user = User.new(params[:user])
    respond_to do |format|
     if @user.save
        format.js {render 'user_created'}
     else
        format.js { render 'user_create_failed' }
     end
    end
  end
  
  def upload_avatar
    respond_to do |format|
     if current_user.update_attributes(params[:project])
       format.html { redirect_to profile_path, :notice => t("users.messages.upload_avatar.success") }
     else
       format.html { redirect_to profile_path, :notice => t("users.messages.upload_avatar.fail") }
     end
   end
  end
  
end
