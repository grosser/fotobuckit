class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false
      t.string :email, :null => false
      t.string :password, :null => false
      t.integer :bucket_id

      t.timestamps
    end

    add_index :users, :email, :unique => true
    add_index :users, :username, :unique => true
  end

  def self.down
    drop_table :users
  end
end
