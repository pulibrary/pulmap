class AddUsernameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string
    change_column  :users, :username, :string, :null => false
    add_index :users, :username, :unique => true
  end

  def self.down
  	remove_column :users, :username, :string
  end
end