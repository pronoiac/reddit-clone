class SubsController < ApplicationController
  before_action :require_user, only: [:new, :create, :edit, :update]
  
  def new
    @sub = Sub.new
    render :new
  end
  
  def create
    user = current_user
    @sub = user.subs.new(sub_params)
    
    if @sub.save
      #login!(@sub)
      flash[:notices] ||= [] << "Sub \"#{ @sub.title }\" created. Success!"
      redirect_to subs_url
    else
      flash[:errors] ||= [] << @sub.errors.full_messages
      render :new
    end
  end
  
  def show
    @sub = Sub.find(params[:id])
    render :show
  end
  
  def edit
    # moderator can edit title and description
    @sub = Sub.find(params[:id])
    render :edit
  end
  
  def update
    @sub = Sub.find(params[:id])
    
    if @sub.update_attributes(sub_params)
      flash[:notices] ||= [] << "Sub \"#{ @sub.title }\" edited!"
      redirect_to sub_url(@sub)
    else
      flash[:errors] ||= [] << @sub.errors.full_messages
      render :edit
    end
  end
  
  def index
    @subs = Sub.all
    render :index
  end
  
  private
  
  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end
  
  def require_user
    return if logged_in?
    flash[:errors] ||= [] << "Must be logged in to create a sub."
    redirect_to subs_url unless logged_in?
  end
  
end
