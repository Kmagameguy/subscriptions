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

ActiveRecord::Schema[7.2].define(version: 2024_10_14_230001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "price_histories", force: :cascade do |t|
    t.bigint "subscription_id", null: false
    t.decimal "price"
    t.datetime "effective_date"
    t.integer "price_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_price_histories_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "name", null: false
    t.string "url"
    t.integer "price_type", default: 0
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "password_confirmation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "price_histories", "subscriptions"
  add_foreign_key "subscriptions", "users"
end
