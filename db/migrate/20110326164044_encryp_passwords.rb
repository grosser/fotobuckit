class EncrypPasswords < ActiveRecord::Migration
  def self.up
    rename_column :users, :password, :hashed_password
    add_column :users, :salt, :string
#    User.update_all 'salt = "abcasdasdasd321231"'
    change_column :users, :salt, :string, :null => false
  end

  def self.down
  end
end
