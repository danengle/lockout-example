class AddLockedOutAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :locked_out_at, :datetime
  end

  def self.down
    remove_column :users, :locked_out_at
  end
end
