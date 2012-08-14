class CommentsController < ApplicationController
  
  before_filter :authenticate
  respond_to :html, :json, :js
  
  def index
    @comments = Comment.all
    respond_with @comments
  end

  def show
    @comment = Comment.find(params[:id])
    respond_with @comment
  end

  def new
    @comment = Comment.new
    respond_with @comment
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    flash[:notice] = 'Comment was successfully created.' if @comment.save
    respond_with @comment
  end

  def update
    @comment = Comment.find(params[:id])
    flash[:notice] = 'Comment was successfully updated.' if @comment.update_attributes(params[:comment])                                                   
    respond_with @comment
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_with @comment
  end
end
