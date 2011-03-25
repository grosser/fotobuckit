require 'spec_helper'

describe SessionsController do
  let(:user){Factory(:user)}

  describe :create do
    it "logs me in with username/password" do
      post :create, :username => user.username, :password => user.password
      session[:user_id].should == user.id
      response.should redirect_to('/')
    end

    it "logs me in with email/password" do
      post :create, :username => user.email, :password => user.password
      session[:user_id].should == user.id
      response.should redirect_to('/')
    end

    it "renders new when i cannot log in" do
      post :create, :username => user.email, :password => user.password+'x'
      session[:user_id].should == nil
      response.should render_template(:new)
    end
  end

  describe :destroy do
    it "logs me out" do
      login_as user
      delete :destroy
      session[:user_id].should == nil
      response.should redirect_to('/')
    end
  end
end
