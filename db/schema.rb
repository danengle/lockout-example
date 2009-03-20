# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090320025507) do

  create_table "login_attempts", :force => true do |t|
    t.string   "remote_ip"
    t.string   "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "login_attempts", ["remote_ip"], :name => "index_login_attempts_on_remote_ip"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "restricted_ips", :force => true do |t|
    t.string   "remote_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restricted_ips", ["remote_ip"], :name => "index_restricted_ips_on_remote_ip"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.string   "role",                                     :default => "member"
    t.datetime "deleted_at"
    t.datetime "locked_out_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
