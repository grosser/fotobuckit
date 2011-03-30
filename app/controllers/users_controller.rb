class UsersController < ApplicationController
  before_filter :login_required, :only => :update

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      self.current_user = @user
      redirect_to '/', :notice => 'Welcome on board!'
    else
      render 'new'
    end
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to '/', :notice => 'Saved!'
    else
      render 'edit'
    end
  end
end
