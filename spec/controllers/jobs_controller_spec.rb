require 'spec_helper'

describe JobsController do
  let(:job){Factory(:job)}

  describe :show do
    before do
      login_as job.user
    end

    it "renders" do
      get :show, :id => job.id
      assigns[:job].should == job
      response.should render_template(:show)
    end
  end

  describe :update do
    before do
      login_as job.user
    end

    it "sets new values" do
      lambda{
        put :update, :id => job.id, :job => {:title => 'xxx'}
      }.should change{job.reload.title}
      response.should redirect_to(job)
    end

    it "stops on error" do
      lambda{
        put :update, :id => job.id, :job => {:title => ''}
      }.should_not change{job.reload.title}
      response.should render_template('show')
    end
  end
end
