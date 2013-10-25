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

ActiveRecord::Schema.define(version: 20131015181545) do

  create_table "bonuses", force: true do |t|
    t.string   "type",                     null: false
    t.integer  "regeneration", default: 0, null: false
    t.integer  "clicks",       default: 0, null: false
    t.integer  "steals",       default: 0, null: false
    t.integer  "saves",        default: 0, null: false
    t.integer  "stockpile_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bonuses", ["stockpile_id"], name: "index_bonuses_on_stockpile_id", using: :btree

  create_table "buckets", force: true do |t|
    t.integer  "cookies",    limit: 8, default: 0
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hunters", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hunters", ["email"], name: "index_hunters_on_email", unique: true, using: :btree
  add_index "hunters", ["reset_password_token"], name: "index_hunters_on_reset_password_token", unique: true, using: :btree

  create_table "stockpiles", force: true do |t|
    t.integer  "hunter_id",                          null: false
    t.integer  "cookies",      limit: 8, default: 0
    t.integer  "regeneration",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clicks",                 default: 1
    t.integer  "saves",        limit: 8, default: 0
    t.integer  "steals",                 default: 1
  end

  add_index "stockpiles", ["hunter_id"], name: "index_stockpiles_on_hunter_id", using: :btree

end
