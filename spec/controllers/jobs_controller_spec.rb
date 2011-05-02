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

  describe :access do
    before do
      login_as job.user
    end

    it "generated an access code" do
      get :access, :id => job.id, :customer => 'Fred', :period => 1.day.to_i.to_s
      UrlStore.decode(response.body).should == {'id' => job.id, 'customer' => 'Fred', 'until' => 1.day.from_now.to_i}
    end

    it "generated an unlimited access code" do
      get :access, :id => job.id, :customer => 'Fred', :period => '0'
      UrlStore.decode(response.body).should == {'id' => job.id, 'customer' => 'Fred'}
    end
  end

  describe :iframe do
    let(:job){ Factory(:job) }

    it "cannot be accessed normally" do
      get :iframe, :id => job.id
      response.body.should == "ACCESS DENIED"
    end

    it "cannot be accessed via login" do
      login_as job.user
      get :iframe, :id => job.id
      response.body.should == "ACCESS DENIED"
    end

    it "can be accessed via iframe access" do
      get :iframe, :id => job.id, :access => job.user.iframe_access
      response.body.should_not == "ACCESS DENIED"
    end
  end
end
