ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)
require 'rspec/rails'

RSpec.configure do
  def login_as(user)
    controller.stub!(:current_user).and_return user
  end

  def referrer(url)
    @request.env['HTTP_REFERER'] = url
  end

  def stop_time
    time = Time.now
    Time.stub!(:now).and_return time
  end
end
