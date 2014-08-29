class UsersController < ApplicationController
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      login!(@user)
      # fail
      redirect_to subs_url
    else
      flash[:errors] = @user.errors.full_messages
      render :new
    end
  end
  
  def index
    @users = User.all
    render :index
  end
  
  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
  
end
