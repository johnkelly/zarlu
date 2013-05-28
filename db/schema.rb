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

ActiveRecord::Schema.define(version: 20130528002818) do

  create_table "accruals", force: true do |t|
    t.string  "type"
    t.integer "subscriber_id"
    t.integer "start_year"
    t.integer "end_year"
    t.decimal "rate"
  end

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["trackable_id"], name: "index_activities_on_trackable_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "company_settings", force: true do |t|
    t.string   "type"
    t.integer  "subscriber_id"
    t.boolean  "enabled",           default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "accrual_frequency", default: 0
    t.date     "next_accrual"
    t.decimal  "accrual_limit"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "approved",    default: false, null: false
    t.boolean  "rejected",    default: false, null: false
    t.integer  "kind",        default: 0,     null: false
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "leaves", force: true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.decimal  "accrued_hours", default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "used_hours",    default: 0.0, null: false
    t.decimal  "pending_hours", default: 0.0, null: false
  end

  create_table "subscribers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer_token"
    t.string   "card_last4"
    t.string   "card_type"
    t.string   "name"
    t.string   "time_zone",      default: "Pacific Time (US & Canada)"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscriber_id"
    t.integer  "manager_id"
    t.boolean  "manager",                default: false, null: false
    t.text     "properties"
    t.string   "name"
    t.date     "join_date"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
