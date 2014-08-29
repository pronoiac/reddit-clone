class SessionsController < ApplicationController
  
  def new
    @user = User.new
    render :new
  end
  
  def create
    user = User.find_by_credentials(
        params[:user][:username],
        params[:user][:password]
    )
    
    if user
      login!(user)
      # fail
      redirect_to users_url
    else
      flash[:error] = user.errors.full_messages
      render :new
    end
   
  end
  
  def destroy
    current_user.reset_session_token
    session[:session_token] = nil
    redirect_to users_url
  end
  
end
