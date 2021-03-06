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

ActiveRecord::Schema.define(version: 2018_12_25_081731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "course_code"
    t.string "course_type"
    t.string "teaching_type"
    t.string "exam_type"
    t.string "credit"
    t.integer "limit_num"
    t.integer "student_num", default: 0
    t.string "class_room"
    t.string "course_time"
    t.string "course_week"
    t.integer "teacher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "open", default: false
  end

  create_table "demos", force: :cascade do |t|
    t.string "title"
    t.string "name"
    t.string "uptime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grades", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
    t.integer "grade"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "degree"
    t.index ["course_id"], name: "index_grades_on_course_id"
    t.index ["user_id"], name: "index_grades_on_user_id"
  end

  create_table "lectures", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notices", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notices_on_user_id"
  end

  create_table "opensystems", id: :serial, force: :cascade do |t|
    t.boolean "isopen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "num"
    t.string "major"
    t.string "department"
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.boolean "teacher", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
