class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :auth_token, :current_user, :logged_in?
  
  def auth_token
    token = '<input type="hidden" name="authenticity_token" value="'
    token += form_authenticity_token
    token += '">'
    token.html_safe
  end
  
  def login!(user)
    user.session_token = user.generate_session_token
    session[:session_token] = user.session_token
    @current_user = user
    user.save!
  end
  
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end
  
  def logged_in?
    !!current_user
  end
  
end
