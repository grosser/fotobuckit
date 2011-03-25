class JobsController < ApplicationController
  before_filter :login_required

  def show
    @job = current_user.jobs.find(params[:id])
  end
end
