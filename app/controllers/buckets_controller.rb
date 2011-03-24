class BucketsController < ApplicationController
  before_filter :login_required
  before_filter :find_bucket, :only => [:show, :edit, :update, :destroy]

  def new
    @bucket = Bucket.new
  end

  def create
    @bucket = Bucket.create!(params[:bucket].merge(:user => current_user))
    redirect_to @bucket
  end

  def update
    @bucket.update_attributes!(params[:bucket])
    redirect_to @bucket
  end

  private

  def find_bucket
    @bucket = Bucket.find_by_name(params[:id]) || raise(ActiveRecord::RecordNotFound)
  end
end
