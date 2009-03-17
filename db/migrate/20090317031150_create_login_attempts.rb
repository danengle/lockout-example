class CreateLoginAttempts < ActiveRecord::Migration
  def self.up
    create_table :login_attempts do |t|
      t.string :remote_ip, :user_agent
      t.timestamps
    end
    add_index :login_attempts, :remote_ip
  end

  def self.down
    drop_table :login_attempts
    remove_index :login_attempts, :remote_ip
  end
end
