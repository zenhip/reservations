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

ActiveRecord::Schema.define(:version => 20080821120411) do

  create_table "assets", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "height"
    t.integer  "width"
    t.integer  "product_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batches", :force => true do |t|
    t.integer  "product_id",                :null => false
    t.integer  "quantity",   :default => 0
    t.datetime "arrive_on",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.datetime "leave_on"
    t.integer  "quantity"
    t.integer  "completed",  :default => 0
  end

  create_table "orders_from_batches", :force => true do |t|
    t.integer  "order_id",   :null => false
    t.integer  "batch_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
  end

  create_table "products", :force => true do |t|
    t.string   "name",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "visible",     :default => 1
    t.text     "description"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "role",                      :limit => 12
  end

end
