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

ActiveRecord::Schema.define(version: 20160913205859) do

  create_table "manufacturers", force: true do |t|
    t.string   "name"
    t.string   "about"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "product_type"
    t.float    "apv"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manufacturer_id"
  end

  add_index "products", ["manufacturer_id"], name: "index_products_on_manufacturer_id"

  create_table "reviews", force: true do |t|
    t.string   "body"
    t.string   "rating"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
