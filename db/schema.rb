# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_24_233107) do
  create_table "course_enrollments", primary_key: ["course_id", "student_id"], force: :cascade do |t|
    t.integer "course_id"
    t.integer "student_id"
    t.string "status"
    t.datetime "enrolled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollment_notes", force: :cascade do |t|
    t.integer "course_id"
    t.integer "student_id"
    t.text "note_text"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reviewed", default: false
    t.datetime "reviewed_at"
    t.string "reviewed_by"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requirements", force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_requirements_on_user_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "grade_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_organizations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_user_organizations_on_organization_id"
    t.index ["user_id"], name: "index_user_organizations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "enrollment_notes", "course_enrollments", column: ["course_id", "student_id"], primary_key: ["course_id", "student_id"]
  add_foreign_key "requirements", "users"
  add_foreign_key "user_organizations", "organizations"
  add_foreign_key "user_organizations", "users"
end
