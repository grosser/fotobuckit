class JobsController < ApplicationController
  before_filter :login_required, :except => :iframe
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
    @current_user = false
    @job = Job.find(params[:id])
    if @job.user.iframe_access == params[:access]
      render :action => :show, :layout => 'plain'
    else
      render :text => 'ACCESS DENIED'
    end
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
