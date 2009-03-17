class CreateRestrictedIps < ActiveRecord::Migration
  def self.up
    create_table :restricted_ips do |t|
      t.string :remote_ip
      t.timestamps
    end
    add_index :restricted_ips, :remote_ip
  end

  def self.down
    drop_table :restricted_ips
    remove_index :restricted_ips, :remote_ip
  end
end
