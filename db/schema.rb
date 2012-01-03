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

ActiveRecord::Schema.define(:version => 9) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id",   :default => 0
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "name"
    t.integer  "image_id"
    t.string   "ip"
    t.text     "comment"
    t.datetime "created_at"
  end

  add_index "comments", ["image_id"], :name => "index_comments_on_image_id"

  create_table "hits", :force => true do |t|
    t.integer "image_id",                :null => false
    t.integer "hits",     :default => 0
  end

  create_table "images", :force => true do |t|
    t.string   "url"
    t.string   "thumb_url"
    t.string   "pinky_url"
    t.string   "width",       :default => "0"
    t.string   "height",      :default => "0"
    t.string   "description", :default => "No Description."
    t.integer  "category_id", :default => 1
    t.integer  "user_id",     :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string "name"
    t.string "setting_type"
    t.string "value"
    t.string "description"
    t.string "item_type"
  end

  add_index "settings", ["name"], :name => "index_settings_on_name", :unique => true

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.integer  "image_id"
    t.text     "name"
    t.integer  "parent_id",  :default => 0
    t.datetime "created_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password_hash"
    t.string   "salt"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

end
