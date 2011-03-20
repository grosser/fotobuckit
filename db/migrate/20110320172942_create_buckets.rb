class CreateBuckets < ActiveRecord::Migration
  def self.up
    create_table :buckets do |t|
      t.string :name
      t.string :access_key_id
      t.string :secret_access_key

      t.timestamps
    end
  end

  def self.down
    drop_table :buckets
  end
end
