class S3File < ActiveRecord::Base
  belongs_to :bucket

  def url
    bucket.s3.get_link(bucket.name, key) + "&i=#{last_modified.to_i}"
  end

  def title
    File.basename(key)
  end
end
