class SearchController < ApplicationController
  
  before_filter :authenticate
  respond_to :js, :html
  
  def index
    @projects = Project.where("title ILIKE '%#{params[:search]}%'")
  end
end
