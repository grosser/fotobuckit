class S3File < ActiveRecord::Base
  belongs_to :user

  def url
    user.s3.get_link(user.bucket, key) + "&i=#{last_modified.to_i}"
  end

  def title
    File.basename(key)
  end
end
