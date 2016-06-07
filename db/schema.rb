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

ActiveRecord::Schema.define(version: 20160607010850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
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
    t.string   "last_name"
    t.string   "salutation"
    t.string   "role"
    t.date     "date_started"
    t.date     "date_departed"
    t.text     "notes"
  end

  add_index "contacts", ["organization_id"], name: "index_contacts_on_organization_id", using: :btree

  create_table "drivers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incident_categories", force: :cascade do |t|
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "incidents", force: :cascade do |t|
    t.datetime "incident_date"
    t.text     "description"
    t.integer  "student_id"
    t.integer  "contact_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "incident_category_id"
  end

  add_index "incidents", ["contact_id"], name: "index_incidents_on_contact_id", using: :btree
  add_index "incidents", ["incident_category_id"], name: "index_incidents_on_incident_category_id", using: :btree
  add_index "incidents", ["student_id"], name: "index_incidents_on_student_id", using: :btree

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

  create_table "placements", force: :cascade do |t|
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

  add_index "placements", ["contact_id"], name: "index_placements_on_contact_id", using: :btree
  add_index "placements", ["student_id"], name: "index_placements_on_student_id", using: :btree

  create_table "route_stops", force: :cascade do |t|
    t.string   "stop_order"
    t.integer  "van_route_id"
    t.integer  "placement_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "route_stops", ["placement_id"], name: "index_route_stops_on_placement_id", using: :btree
  add_index "route_stops", ["van_route_id"], name: "index_route_stops_on_van_route_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "powerschool_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "mobile_phone"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "admin",                  default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "van_routes", force: :cascade do |t|
    t.string   "name"
    t.date     "route_date"
    t.string   "am_pm"
    t.integer  "van_id"
    t.integer  "driver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "van_routes", ["driver_id"], name: "index_van_routes_on_driver_id", using: :btree
  add_index "van_routes", ["van_id"], name: "index_van_routes_on_van_id", using: :btree

  create_table "vans", force: :cascade do |t|
    t.string   "name"
    t.string   "plate_number"
    t.string   "vin"
    t.string   "make"
    t.string   "model_year"
    t.string   "last_oil_change"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "capacity"
  end

  add_foreign_key "contacts", "organizations"
  add_foreign_key "incidents", "contacts"
  add_foreign_key "incidents", "incident_categories"
  add_foreign_key "incidents", "students"
  add_foreign_key "placements", "contacts"
  add_foreign_key "placements", "students"
  add_foreign_key "route_stops", "placements"
  add_foreign_key "route_stops", "van_routes"
  add_foreign_key "van_routes", "drivers"
  add_foreign_key "van_routes", "vans"
end
