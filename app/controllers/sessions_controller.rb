class SessionsController < ApplicationController
  def create
    if user = User.authorize(params[:username], params[:password])
      self.current_user = user
      redirect_to '/'
    else
      flash[:error] = 'Invalid username/email or password'
      render 'new'
    end
  end

  def destroy
    self.current_user = nil
    redirect_to '/'
  end
end
