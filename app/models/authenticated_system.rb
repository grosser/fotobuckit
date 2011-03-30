module AuthenticatedSystem
  def self.included(base)
    base.helper_method :current_user
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.try(:id)
  end

  def login_required
    redirect_to '/', :alert => 'You need to log in!' unless current_user
  end

  def redirect_back_or_default(x, options={})
    redirect_to (request.headers["Referer"] ? :back : x), options
  end
end
