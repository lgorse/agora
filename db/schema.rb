# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130802034833) do

  create_table "account_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invitations", :force => true do |t|
    t.integer  "inviter_id"
    t.integer  "account_id"
    t.string   "email"
    t.boolean  "accepted",   :default => false
    t.integer  "invitee_id"
    t.text     "message"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "motion_users", :force => true do |t|
    t.integer  "motion_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "motions", :force => true do |t|
    t.integer  "created_by"
    t.integer  "account_id"
    t.string   "details"
    t.string   "title"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "email_sent", :default => false
    t.datetime "expires_at"
    t.datetime "email_time"
    t.boolean  "anonymous",  :default => false
  end

  create_table "replies", :force => true do |t|
    t.integer  "motion_id"
    t.integer  "user_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "default_account"
    t.string   "name"
    t.string   "email"
    t.string   "team"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "admin",           :default => false
    t.boolean  "email_notify",    :default => true
  end

end
