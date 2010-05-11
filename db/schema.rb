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

ActiveRecord::Schema.define(:version => 20100507184951) do

  create_table "data_files", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licenses", :force => true do |t|
    t.string   "ls_id",       :null => false
    t.string   "user_id",     :null => false
    t.string   "domain",      :null => false
    t.text     "description", :null => false
    t.string   "is_source",   :null => false
    t.string   "source1",     :null => false
    t.string   "source2"
    t.string   "source3"
    t.string   "source4"
    t.string   "source5"
    t.string   "source6"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mashups", :force => true do |t|
    t.string   "key"
    t.string   "url"
    t.string   "user"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peoples", :force => true do |t|
    t.string   "title"
    t.string   "location"
    t.string   "group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                 :null => false
    t.string   "email",                                :null => false
    t.string   "password",                             :null => false
    t.text     "usergroup",  :default => "Registered", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
