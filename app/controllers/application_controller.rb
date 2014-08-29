class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :auth_token
  
  def auth_token
    token = '<input type="hidden" name="authenticity_token" value="'
    token += form_authenticity_token
    token += '">'
    token.html_safe
  end
end
