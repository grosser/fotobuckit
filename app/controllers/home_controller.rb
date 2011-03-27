class HomeController < ApplicationController
  def index
    if current_user
      render 'dashboard'
    else
      render 'index'
    end
  end

  def iframe_content
    render :layout => false
  end
end
