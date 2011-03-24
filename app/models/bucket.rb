class Bucket < ActiveRecord::Base
  validates :access_key_id, :length => 20..20
  validates :secret_access_key, :length => 40..40

  has_many :s3_files, :dependent => :destroy
  has_one :user

  def to_param
    name
  end

  def sync_files
    s3_files.delete_all
    keys.each do |data|
      key = data[:key]
      next unless key =~ /\.(je?pg|gif|tiff|bmp|raw)$/i
      s3_files.create!(
        :key => key,
        :folder => File.dirname(key),
        :last_modified => Time.parse(data[:last_modified])
      )
    end
  end

  def keys
    s3.list_bucket(name)
  end

  def s3
    @s3 ||= RightAws::S3Interface.new(access_key_id, secret_access_key)
  end
end
