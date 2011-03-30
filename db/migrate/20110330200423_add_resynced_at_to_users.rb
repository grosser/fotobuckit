class AddResyncedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :synced_at, :timestamp
  end

  def self.down
    remove_column :users, :synced_at
  end
end
