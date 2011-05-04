class CreateAccess < ActiveRecord::Migration
  def self.up
    create_table :accesses do |t|
      t.integer :user_id, :null => false
      t.integer :job_id
      t.string :token, :name, :null => false
      t.timestamp :valid_to, :valid_from
      t.timestamps
    end
    add_index :accesses, :token, :unique => true
    add_index :accesses, [:user_id, :name], :unique => true
  end

  def self.down
    drop_table :accesses
  end
end
