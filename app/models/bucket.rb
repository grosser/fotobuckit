class Bucket < ActiveRecord::Base
  def to_param
    name
  end

  def keys
    s3.list_bucket(name)
  end

  private

  def s3
    @s3 ||= RightAws::S3Interface.new(access_key_id, secret_access_key)
  end
end
