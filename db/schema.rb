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

ActiveRecord::Schema.define(:version => 20130909142028) do

  create_table "devices", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "type"
    t.string   "status"
    t.string   "custom_value"
    t.binary   "icon"
  end

  create_table "message_templates", :force => true do |t|
    t.string   "name"
    t.string   "subject"
    t.text     "body"
    t.string   "address"
    t.string   "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.string   "value"
    t.datetime "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "device_id"
  end

  create_table "meter", :force => true do |t|
    t.integer "countable_id"
    t.string  "countable_type"
    t.integer "start_value"
    t.integer "current_value"
  end

  add_index "meter", ["countable_type", "countable_id"], :name => "index_counters_on_countable_type_and_countable_id", :unique => true

  create_table "provider_configs", :force => true do |t|
    t.integer  "provider_id"
    t.string   "key"
    t.string   "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "providers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "type"
    t.integer  "receiver_id"
    t.string   "receiver_type"
  end

  add_index "providers", ["receiver_type", "receiver_id"], :name => "index_providers_on_receiver_type_and_receiver_id"

  create_table "reports", :force => true do |t|
    t.string   "name"
    t.integer  "message_template_id"
    t.string   "message_template_type"
    t.integer  "device_id"
    t.string   "device_type"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "scheduler_logs", :force => true do |t|
    t.integer  "scheduler_id"
    t.text     "scheduler_log"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "schedulers", :force => true do |t|
    t.string   "name"
    t.datetime "mask"
    t.integer  "shift"
    t.datetime "alarm"
    t.integer  "schedulable_id"
    t.string   "schedulable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "wifly_configs", :force => true do |t|
    t.string   "subtype"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
