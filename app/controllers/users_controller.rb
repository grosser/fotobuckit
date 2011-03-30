class UsersController < ApplicationController
  before_filter :login_required, :only => [:update, :sync]

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

  def sync
    current_user.sync_files
    redirect_back_or_default '/', :notice => 'Its done!'
  end
end
