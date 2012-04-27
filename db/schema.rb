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

ActiveRecord::Schema.define(:version => 20120427110948) do

  create_table "colors", :force => true do |t|
    t.string   "name"
    t.string   "html_val",   :default => "#ffffff"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "top_category_id"
    t.string   "name",            :default => ""
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.text     "description"
  end

  create_table "images", :force => true do |t|
    t.integer  "product_id"
    t.string   "file_name"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "event_id"
    t.integer  "event_big_id"
  end

  create_table "products", :force => true do |t|
    t.integer  "event_id"
    t.integer  "color_id"
    t.integer  "size_id"
    t.string   "name"
    t.text     "description"
    t.integer  "amount",                                     :default => 0
    t.decimal  "price",       :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                  :null => false
    t.datetime "updated_at",                                                  :null => false
  end

  create_table "properties", :force => true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sizes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "top_categories", :force => true do |t|
    t.string   "name",       :default => ""
    t.integer  "sorting",    :default => 1
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "mail"
    t.string   "pass"
    t.integer  "role_id",                          :default => 1
    t.string   "ip",                               :default => ""
    t.string   "country"
    t.string   "city"
    t.text     "serialized_fb_graph"
    t.integer  "fb_id",               :limit => 8
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "shop_category_id"
    t.boolean  "us_ship"
  end

  create_table "worldwide_tariffs", :force => true do |t|
    t.string   "country"
    t.decimal  "w_0_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_1_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_1_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_2_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_2_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_3_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_3_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_4_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_4_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_5_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_5_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_6_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_6_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_7_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_7_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_8_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_8_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_9_0",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_9_5",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_10_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_10_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_11_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_11_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_12_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_12_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_13_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_13_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_14_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_14_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_15_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_15_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_16_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_16_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_17_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_17_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_18_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_18_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_19_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_19_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_20_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_20_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_21_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_21_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_22_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_22_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_23_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_23_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_24_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_24_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_25_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_25_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_26_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_26_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_27_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_27_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_28_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_28_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_29_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_29_5",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "w_30_0",     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "additional", :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

end
