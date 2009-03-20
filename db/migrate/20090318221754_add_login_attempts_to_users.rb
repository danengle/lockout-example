class AddLoginAttemptsToUsers < ActiveRecord::Migration
  def self.up
    add_column :login_attempts, :user_id, :integer
  end

  def self.down
    remove_column :login_attempts, :user_id
  end
end
