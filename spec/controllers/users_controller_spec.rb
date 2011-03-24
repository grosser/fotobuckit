require 'spec_helper'

describe UsersController do
  describe :new do
    it "renders" do
      get :new
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

    it "renders new on failure" do
      lambda{
        post :create, :user => {:username => '', :email => 'asdasd@sadasd.dd', :password => 'xyzxyzxyz'}
      }.should_not change{User.count}
      response.should render_template(:new)
    end
  end
end
