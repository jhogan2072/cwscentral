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

ActiveRecord::Schema.define(version: 20171013112451) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_assignments", force: :cascade do |t|
    t.date     "effective_start_date"
    t.date     "effective_end_date"
    t.integer  "organization_id"
    t.integer  "contact_id"
    t.string   "title"
    t.string   "department"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "business_email"
    t.string   "office_phone"
    t.string   "fax"
    t.string   "role"
    t.text     "notes"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "cc_days"
  end

  add_index "contact_assignments", ["contact_id"], name: "index_contact_assignments_on_contact_id", using: :btree

  create_table "contact_stagings", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "salutation"
    t.string   "dear"
    t.string   "personal_mobile"
    t.string   "start_date"
    t.string   "organization_name"
    t.string   "title"
    t.string   "department"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "business_email"
    t.string   "office_phone"
    t.string   "fax"
    t.string   "role"
    t.boolean  "duplicate"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "personal_email"
    t.string   "personal_mobile"
    t.integer  "designations"
    t.date     "start_date"
    t.string   "sugarcrm_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "last_name"
    t.string   "salutation"
    t.string   "dear"
  end

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
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "incident_category_id"
    t.integer  "contact_assignment_id"
  end

  add_index "incidents", ["contact_assignment_id"], name: "index_incidents_on_contact_assignment_id", using: :btree
  add_index "incidents", ["incident_category_id"], name: "index_incidents_on_incident_category_id", using: :btree
  add_index "incidents", ["student_id"], name: "index_incidents_on_student_id", using: :btree

  create_table "org_stagings", force: :cascade do |t|
    t.string   "name"
    t.string   "billing_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "sponsor_since"
    t.boolean  "duplicate"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

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

  create_table "placement_stagings", force: :cascade do |t|
    t.string   "student_first_name"
    t.string   "student_last_name"
    t.string   "student_middle_name"
    t.string   "contact_first_name"
    t.string   "contact_last_name"
    t.string   "organization_name"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "paid"
    t.string   "work_day"
    t.string   "student_gradelevel"
    t.string   "earliest_start"
    t.string   "latest_start"
    t.string   "ideal_start"
    t.boolean  "duplicate"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
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
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "contact_assignment_id"
    t.string   "notes"
  end

  add_index "placements", ["contact_assignment_id"], name: "index_placements_on_contact_assignment_id", using: :btree
  add_index "placements", ["student_id"], name: "index_placements_on_student_id", using: :btree

  create_table "route_stops", force: :cascade do |t|
    t.string   "am_order"
    t.integer  "van_route_id"
    t.integer  "placement_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "pm_order"
    t.string   "notes"
    t.string   "am_notes"
    t.string   "pm_notes"
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
    t.string   "skills"
    t.string   "goals"
    t.boolean  "active"
    t.integer  "classof"
    t.string   "leave_reason"
  end

  create_table "students_stagings", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "mobile_phone"
    t.string   "skills"
    t.string   "goals"
    t.boolean  "active"
    t.boolean  "duplicate"
    t.string   "powerschool_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "classof"
  end

  create_table "students_van_routes", id: false, force: :cascade do |t|
    t.integer "van_route_id", null: false
    t.integer "student_id",   null: false
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
    t.integer  "van_id"
    t.integer  "driver_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "check_in_time"
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
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "capacity"
    t.boolean  "out_of_service",       default: false
    t.date     "expected_return_date"
  end

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

  add_foreign_key "contact_assignments", "contacts"
  add_foreign_key "contact_assignments", "organizations"
  add_foreign_key "incidents", "contact_assignments"
  add_foreign_key "incidents", "incident_categories"
  add_foreign_key "incidents", "students"
  add_foreign_key "placements", "contact_assignments"
  add_foreign_key "placements", "students"
  add_foreign_key "route_stops", "placements"
  add_foreign_key "route_stops", "van_routes"
  add_foreign_key "van_routes", "drivers"
  add_foreign_key "van_routes", "vans"
end
