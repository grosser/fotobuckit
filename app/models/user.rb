class User < ActiveRecord::Base
  include HashedPassword

  validates :username, :uniqueness => true, :length => 4..20, :format => /^[-a-zA-Z_\d]+$/
  validates :email, :uniqueness => true, :length => 4..100, :format => /^.+@.+\..+$/
  validates :bucket, :uniqueness => true, :length => 1..200, :allow_blank => true
  validates :access_key_id, :length => 20..20, :allow_blank => true
  validates :secret_access_key, :length => 40..40, :allow_blank => true

  has_many :s3_files, :dependent => :destroy
  has_many :jobs, :dependent => :destroy

  after_update :sync_files, :if => :s3_credentials_changed?

  def credentials_filled?
    bucket.present? and access_key_id.present? and secret_access_key.present?
  end

  def sync_expired?
    not synced_at or synced_at < 30.seconds.ago
  end

  def sync_files
    update_attribute(:synced_at, Time.current)
    s3_files.delete_all

    keys.each do |data|
      key = data[:key]
      next unless key =~ /\.(je?pg|gif|tiff|bmp|raw)$/i

      folder = File.dirname(key)
      job = jobs.detect{|job| job.folder == folder }
      job ||= jobs.create!(:folder => folder, :title => folder)

      s3_files.create!(
        :key => key,
        :folder => folder,
        :last_modified => Time.parse(data[:last_modified]),
        :job => job
      )
    end
  end

  def keys
    s3.list_bucket(bucket)
  end

  def s3
    @s3 ||= RightAws::S3Interface.new(access_key_id, secret_access_key)
  end

  private

  def s3_credentials_changed?
    bucket_changed? or access_key_id_changed? or secret_access_key_changed?
  end
end
