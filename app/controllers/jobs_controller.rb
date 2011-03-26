class JobsController < ApplicationController
  before_filter :login_required
  before_filter :find_job

  def show
  end

  def update
    if @job.update_attributes(params[:job])
      redirect_to @job, :notice => 'Saved!'
    else
      render 'show'
    end
  end

  private

  def find_job
    @job = current_user.jobs.find(params[:id])
  end
end
