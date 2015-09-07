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

ActiveRecord::Schema.define(version: 20150907065202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.text     "action"
    t.text     "comment"
    t.string   "context_type"
    t.integer  "context_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "chair_id"
    t.string   "actor"
  end

  create_table "chairs", force: true do |t|
    t.string   "title"
    t.string   "abbr"
    t.string   "chief"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "faculty"
    t.string   "contingent_abbr"
  end

  create_table "gpodays", force: true do |t|
    t.date     "date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "kt",         default: false
  end

  create_table "issues", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "planned_closing_at"
    t.integer  "planned_grade"
    t.date     "closed_at"
    t.integer  "grade"
    t.text     "results"
    t.integer  "participant_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "order_projects", force: true do |t|
    t.integer  "order_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: true do |t|
    t.string   "number"
    t.date     "approved_at"
    t.integer  "chair_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "type"
    t.string   "state"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.text     "file_url"
  end

  create_table "participants", force: true do |t|
    t.integer  "student_id"
    t.string   "state"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "project_id"
    t.integer  "course"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "edu_group"
    t.boolean  "contingent_active"
    t.boolean  "contingent_gpo"
    t.boolean  "undergraduate"
    t.string   "subfaculty"
    t.string   "faculty"
    t.boolean  "executive",         default: false
    t.string   "type"
    t.string   "university"
  end

  create_table "people", force: true do |t|
    t.string   "email",       limit: 100
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "middle_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "post"
    t.integer  "chair_id"
    t.string   "float"
    t.string   "phone"
    t.string   "uid"
    t.string   "user_id"
  end

  add_index "people", ["email"], name: "index_people_on_email", using: :btree
  add_index "people", ["uid"], name: "index_people_on_uid", using: :btree

  create_table "permissions", force: true do |t|
    t.string   "user_id"
    t.string   "role"
    t.string   "context_type"
    t.integer  "context_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "old_user_uid"
    t.integer  "old_user_id"
  end

  add_index "permissions", ["user_id", "role", "context_id", "context_type"], name: "by_user_and_role_and_context", using: :btree

  create_table "project_managers", force: true do |t|
    t.integer  "person_id"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "state"
  end

  create_table "projects", force: true do |t|
    t.string   "cipher"
    t.string   "title"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "chair_id"
    t.text     "stakeholders"
    t.text     "funds_required"
    t.text     "funds_sources"
    t.text     "purpose"
    t.text     "features"
    t.text     "analysis"
    t.text     "novelty"
    t.text     "expected_results"
    t.text     "release_cost"
    t.text     "forecast"
    t.string   "state"
    t.string   "editable_state"
    t.text     "close_reason"
    t.integer  "theme_id"
    t.text     "goal"
    t.text     "source_data"
    t.string   "sbi_placing"
    t.string   "interdisciplinary"
    t.string   "category"
    t.string   "result"
    t.date     "closed_on"
  end

  create_table "stages", force: true do |t|
    t.integer  "project_id"
    t.text     "title"
    t.date     "start"
    t.date     "finish"
    t.text     "funds_required"
    t.text     "activity"
    t.text     "results"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "statistics_snapshots", force: true do |t|
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "themes", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visitations", force: true do |t|
    t.integer  "participant_id"
    t.integer  "gpoday_id"
    t.float    "rate"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
