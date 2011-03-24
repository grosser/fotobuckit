class HomeController < ApplicationController
  def index
    render current_user ? 'dashboard' : 'index'
  end
end
