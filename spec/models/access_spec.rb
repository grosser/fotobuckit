require 'spec_helper'

describe Access do
  before do
    Access.delete_all
  end

  describe 'creating' do
    it "creates with job and user" do
      job = Factory(:job)
      Access.create!(:user => job.user, :job => job, :name => 'xxx')
    end

    it "creates general with only user" do
      Access.create!(:user => Factory(:user), :name => 'xxx')
    end

    it "generates a unique token on create" do
      one = Access.create!(:user => Factory(:user), :name => 'xxx')
      two = Access.create!(:user => Factory(:user), :name => 'xx1')
      one.token.size.should == 40
      one.token.should =~ /^[\da-f]+$/
      one.token.should_not == two.token
    end

    it "does not allow job from different user" do
      lambda{
        Access.create!(:user => Factory(:user), :job => Factory(:job))
      }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe :period= do
    it "sets valid_to and valid_from" do
      stop_time
      access = Access.new(:period => 60)
      access.valid_from.to_i.should == Time.now.utc.to_i
      access.valid_to.to_i.should == 60.seconds.from_now.utc.to_i
    end

    it "sets valid_to and valid_from to nil" do
      access = Access.new(:valid_to => Time.now, :valid_from => Time.now)
      access.period = '0'
      access.valid_from.should == nil
      access.valid_to.should == nil
    end
  end
end
