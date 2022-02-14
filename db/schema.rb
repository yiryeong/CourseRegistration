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

ActiveRecord::Schema[7.0].define(version: 2022_02_13_043512) do
  create_table "schedules", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "tutor_id", null: false
    t.bigint "user_id", null: false
    t.integer "lesson_type", null: false
    t.datetime "start_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tutor_id"], name: "index_schedules_on_tutor_id"
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "tutor_schedules", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "tutor_id", null: false
    t.datetime "start_time", null: false
    t.integer "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start_time"], name: "index_tutor_schedules_on_start_time", unique: true
    t.index ["tutor_id"], name: "index_tutor_schedules_on_tutor_id"
  end

  create_table "tutors", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "schedules", "tutors"
  add_foreign_key "schedules", "users"
  add_foreign_key "tutor_schedules", "tutors"
end
