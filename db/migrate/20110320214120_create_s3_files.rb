class CreateS3Files < ActiveRecord::Migration
  def self.up
    create_table :s3_files do |t|
      t.string :key, :null => false
      t.string :folder
      t.timestamp :last_modified, :null => false
      t.integer :bucket_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :s3_files
  end
end
