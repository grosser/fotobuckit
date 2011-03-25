require 'spec_helper'

describe User do
  describe :create_files do
    before do
      S3File.delete_all
      @list_bucket_response = [
        {:key=>"TestFolder/", :last_modified=>"2011-03-20T18:18:29.000Z", :e_tag=>"\"d41d8cd98f00b204e9800998ecf8427e\"", :size=>0, :owner_id=>"e03c712a173b405230d70af47a362a467799cd94053c91604ba81153586c9669", :owner_display_name=>"grossigrosser", :storage_class=>"STANDARD", :service=>{"name"=>"fotobuckit-try", "prefix"=>"", "marker"=>"", "max-keys"=>"1000", "is_truncated"=>false}},
        {:key=>"TestFolder/100_5236.JPG", :last_modified=>"2011-03-20T18:19:08.000Z", :e_tag=>"\"2654407e2a23282970ad0f0877f74c6c\"", :size=>597452, :owner_id=>"e03c712a173b405230d70af47a362a467799cd94053c91604ba81153586c9669", :owner_display_name=>"grossigrosser", :storage_class=>"STANDARD", :service=>{"name"=>"fotobuckit-try", "prefix"=>"", "marker"=>"", "max-keys"=>"1000", "is_truncated"=>false}},
        {:key=>"TestFolder/100_5584.JPG", :last_modified=>"2011-03-20T18:19:23.000Z", :e_tag=>"\"602bd32ca1edf6873e7b51d5494bd5f0\"", :size=>692000, :owner_id=>"e03c712a173b405230d70af47a362a467799cd94053c91604ba81153586c9669", :owner_display_name=>"grossigrosser", :storage_class=>"STANDARD", :service=>{"name"=>"fotobuckit-try", "prefix"=>"", "marker"=>"", "max-keys"=>"1000", "is_truncated"=>false}}
      ]
    end

    let(:user){Factory(:user)}

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
end
