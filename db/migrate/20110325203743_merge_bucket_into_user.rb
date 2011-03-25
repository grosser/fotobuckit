class MergeBucketIntoUser < ActiveRecord::Migration
  def self.up
    drop_table :buckets
    add_column :users, :bucket, :string
    add_column :users, :access_key_id, :string
    add_column :users, :secret_access_key, :string

    add_index :users, :bucket, :unique => true

    S3File.delete_all

    rename_column :s3_files, :bucket_id, :user_id
  end

  def self.down
  end
end
