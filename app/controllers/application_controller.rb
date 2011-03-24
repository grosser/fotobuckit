class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
  end

  def login_required
    redirect_to '/', :error => 'You need to log in!' unless current_user
  end
end
