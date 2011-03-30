require 'spec_helper'

describe UsersController do
  describe :new do
    it "renders" do
      get :new
      assigns[:user].should_not == nil
      response.should render_template(:new)
    end
  end

  describe :create do
    before do
      User.delete_all
    end

    it "creates a user" do
      lambda{
        post :create, :user => {:username => 'asdasd', :email => 'asdasd@sadasd.dd', :password => 'xyzxyzxyz'}
      }.should change{User.count}.by(+1)
      response.should redirect_to('/')
    end

    it "logs me in" do
      post :create, :user => {:username => 'asdasd', :email => 'asdasd@sadasd.dd', :password => 'xyzxyzxyz'}
      session[:user_id].should_not == nil 
    end

    it "renders new on failure" do
      lambda{
        post :create, :user => {:username => '', :email => 'asdasd@sadasd.dd', :password => 'xyzxyzxyz'}
      }.should_not change{User.count}
      response.should render_template(:new)
    end
  end

  describe :update do
    let(:user){Factory(:user)}
    before do
      login_as user
    end

    it "sets new values" do
      lambda{
        put :update, :id => 'xxx', :user => {:email => 'bla@bla.bla'}
      }.should change{user.reload.email}
      response.should redirect_to('/')
    end

    it "stops on error" do
      lambda{
        put :update, :id => 'xxx', :user => {:email => ''}
      }.should_not change{user.reload.email}
      response.should render_template('edit')
    end
  end

  describe :sync do
    let(:user){Factory(:user)}
    before do
      login_as user
    end

    it "syncs the users files" do
      referrer '/xxx'
      user.should_receive(:sync_files)
      get :sync
      response.should redirect_to('/xxx')
    end
  end
end
