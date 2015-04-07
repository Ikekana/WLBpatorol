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

ActiveRecord::Schema.define(version: 20150403043814) do

  create_table "assignments", force: true do |t|
    t.integer  "dept_id"
    t.integer  "emp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignments", ["dept_id"], name: "index_assignments_on_dept_id"
  add_index "assignments", ["emp_id"], name: "index_assignments_on_emp_id"

  create_table "depts", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emps", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", force: true do |t|
    t.date     "holidaydate"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "comment"
  end

  create_table "holidaytypes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "worklogs", force: true do |t|
    t.integer  "dept_id"
    t.integer  "emp_id"
    t.date     "workday"
    t.string   "holiday"
    t.string   "worktype"
    t.time     "rc_start"
    t.time     "wk_start"
    t.time     "wk_end"
    t.time     "rc_end"
    t.integer  "rest"
    t.string   "reason"
    t.string   "comment"
    t.string   "check"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "holidaytype_id"
    t.integer  "worktype_id"
  end

  add_index "worklogs", ["dept_id"], name: "index_worklogs_on_dept_id"
  add_index "worklogs", ["emp_id"], name: "index_worklogs_on_emp_id"

  create_table "worktypes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
