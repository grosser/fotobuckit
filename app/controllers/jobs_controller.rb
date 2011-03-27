class JobsController < ApplicationController
  before_filter :login_required
  before_filter :find_job, :only => [:show, :update]

  def show
  end

  def access
    code = {
      'id' => params[:id],
      'customer' => params[:customer]
    }
    period = params[:period].to_i
    code['until'] = Time.current.to_i + period.to_i unless period == 0
    render :text => UrlStore.encode(code)
  end

  def iframe
    render :text => "CONTENT FOR #{params.except(:action, :controller).to_query}"
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
