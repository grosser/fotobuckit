require 'spec_helper'

describe User do
  before do
    User.delete_all
  end

  describe :sync_files do
    before do
      S3File.delete_all
      @list_bucket_response = [
        {:key=>"TestFolder/", :last_modified=>"2011-03-20T18:18:29.000Z", :e_tag=>"\"d41d8cd98f00b204e9800998ecf8427e\"", :size=>0, :owner_id=>"e03c712a173b405230d70af47a362a467799cd94053c91604ba81153586c9669", :owner_display_name=>"grossigrosser", :storage_class=>"STANDARD", :service=>{"name"=>"fotobuckit-try", "prefix"=>"", "marker"=>"", "max-keys"=>"1000", "is_truncated"=>false}},
        {:key=>"TestFolder/100_5236.JPG", :last_modified=>"2011-03-20T18:19:08.000Z", :e_tag=>"\"2654407e2a23282970ad0f0877f74c6c\"", :size=>597452, :owner_id=>"e03c712a173b405230d70af47a362a467799cd94053c91604ba81153586c9669", :owner_display_name=>"grossigrosser", :storage_class=>"STANDARD", :service=>{"name"=>"fotobuckit-try", "prefix"=>"", "marker"=>"", "max-keys"=>"1000", "is_truncated"=>false}},
        {:key=>"TestFolder/100_5584.JPG", :last_modified=>"2011-03-20T18:19:23.000Z", :e_tag=>"\"602bd32ca1edf6873e7b51d5494bd5f0\"", :size=>692000, :owner_id=>"e03c712a173b405230d70af47a362a467799cd94053c91604ba81153586c9669", :owner_display_name=>"grossigrosser", :storage_class=>"STANDARD", :service=>{"name"=>"fotobuckit-try", "prefix"=>"", "marker"=>"", "max-keys"=>"1000", "is_truncated"=>false}}
      ]
    end

    let(:user){Factory(:user)}

    it "is not called after unimportant updates" do
      user = Factory(:user)
      user.should_not_receive(:sync_files)
      user.update_attributes(:username => 'asdasd')
    end

    it "is called after important changes" do
      user = Factory(:user)
      user.should_receive(:sync_files)
      user.update_attributes(:access_key_id => 'b'*20)
    end

    it "creates files from response hash" do
      user.s3.should_receive(:list_bucket).twice.and_return @list_bucket_response

      lambda{
        user.sync_files
      }.should change{S3File.count}.by(+2)

      lambda{
        user.sync_files
      }.should_not change{S3File.count}
    end

    it "creates new jobs" do
      user.s3.should_receive(:list_bucket).twice.and_return @list_bucket_response

      lambda{
        user.sync_files
      }.should change{Job.count}.by(+1)
      Job.last.folder.should == 'TestFolder'

      lambda{
        user.sync_files
      }.should_not change{Job.count}
    end
  end

  describe :hashed_password do
    it "sets password on create" do
      user = Factory.build(:user, :salt => nil, :hashed_password => nil)
      user.password = 'foobar'
      user.password_confirmation = 'foobar'
      user.save!
      user.salt.should_not == nil
      user.hashed_password.should_not == nil
      User.authorize(user.username, 'foobar').should == user
    end

    it "does not change password on save" do
      user = Factory(:user)
      lambda{
        user.save!
      }.should_not change{user.reload.hashed_password}
    end

    it "can set new password" do
      user = Factory(:user)
      user.update_attributes!(:password => 'barfoo', :password_confirmation => 'barfoo')
      User.authorize(user.username, 'barfoo').should == user
    end

    it "cannot set typo" do
      user = Factory(:user)
      user.update_attributes(:password => 'barfoo', :password_confirmation => 'barfoo2').should == false
    end

    it "can save without password" do
      user = Factory(:user)
      user.update_attributes!(:username => 'xxxxx').should == true
    end
  end
end
