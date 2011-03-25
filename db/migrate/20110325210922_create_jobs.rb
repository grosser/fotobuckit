class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.string :folder
      t.text :description
      t.string :customer

      t.timestamps
    end

    add_index :jobs, [:user_id, :folder], :unique => true

    S3File.delete_all
    add_column :s3_files, :job_id, :integer
    change_column :s3_files, :job_id, :integer, :null => false
  end

  def self.down
    drop_table :jobs
  end
end
