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

ActiveRecord::Schema.define(version: 2018_09_06_181306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "capitals", force: :cascade do |t|
    t.integer "sum"
    t.bigint "user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sign", default: false
    t.boolean "deleted", default: false
  end

  create_table "debts", force: :cascade do |t|
    t.boolean "you_debtor"
    t.bigint "user"
    t.integer "sum", default: 0
    t.boolean "sign", default: true
    t.string "debtor", default: "unspecified"
    t.string "description", default: ""
    t.boolean "local"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destinations", force: :cascade do |t|
    t.string "name"
    t.integer "sum"
    t.date "end_date"
    t.integer "portion_sum"
    t.text "description"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.string "connect"
    t.boolean "deleted"
    t.bigint "user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fast_transactions", force: :cascade do |t|
    t.integer "sum"
    t.bigint "reason"
    t.integer "often"
    t.bigint "user"
    t.boolean "local"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "notices", force: :cascade do |t|
    t.text "text"
    t.bigint "user"
    t.bigint "destination"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tran"
  end

  create_table "plan_tables", force: :cascade do |t|
    t.text "data"
    t.date "date_begin"
    t.date "date_end"
    t.boolean "local"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reasons", force: :cascade do |t|
    t.string "reason"
    t.boolean "sign"
    t.integer "often"
    t.boolean "local"
    t.bigint "user"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "sum"
    t.text "description"
    t.bigint "reason"
    t.bigint "user"
    t.boolean "local"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "surname"
    t.boolean "admin"
    t.bigint "family"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
