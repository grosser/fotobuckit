class UsersController < ApplicationController
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to '/', :notice => 'Welcome on board!'
    else
      render 'new'
    end
  end
end
