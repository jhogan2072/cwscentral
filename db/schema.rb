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

ActiveRecord::Schema.define(version: 20160114231141) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.string   "department"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "email"
    t.string   "mobile"
    t.string   "office_phone"
    t.string   "fax"
    t.integer  "designations"
    t.date     "start_date"
    t.string   "sugarcrm_id"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "contacts", ["organization_id"], name: "index_contacts_on_organization_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "billing_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.date     "sponsor_since"
    t.string   "sugarcrm_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "powerschool_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "work_assignments", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "paid"
    t.string   "work_day"
    t.integer  "student_gradelevel"
    t.string   "earliest_start"
    t.string   "latest_start"
    t.string   "ideal_start"
    t.integer  "student_id"
    t.integer  "contact_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "work_assignments", ["contact_id"], name: "index_work_assignments_on_contact_id", using: :btree
  add_index "work_assignments", ["student_id"], name: "index_work_assignments_on_student_id", using: :btree

  add_foreign_key "contacts", "organizations"
  add_foreign_key "work_assignments", "contacts"
  add_foreign_key "work_assignments", "students"
end
