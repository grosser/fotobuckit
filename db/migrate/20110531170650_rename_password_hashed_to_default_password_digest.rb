class RenamePasswordHashedToDefaultPasswordDigest < ActiveRecord::Migration
  def up
    rename_column :users, :hashed_password, :password_digest
    remove_column :users, :salt
  end

  def down
  end
end
