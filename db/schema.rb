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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140314103219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "order_files", force: true do |t|
    t.string   "original_filename"
    t.string   "uploaded_filename"
    t.integer  "order_id",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.text     "project_name"
    t.hstore   "files"
    t.text     "instructions"
    t.string   "video_length"
    t.string   "cardholder_name"
    t.string   "cardholder_address"
    t.string   "cardholder_city"
    t.string   "cardholder_state"
    t.string   "cardholder_zipcode"
    t.string   "cardholder_email"
    t.string   "cardholder_phone_number"
    t.string   "cc_last_four_no"
    t.string   "cc_exp_at"
    t.string   "status"
    t.string   "secure_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
