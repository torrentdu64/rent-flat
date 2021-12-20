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

ActiveRecord::Schema.define(version: 2021_12_20_020335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.text "request_body"
    t.integer "status", default: 0
    t.text "error_message"
    t.string "source"
    t.string "event_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "flats", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "stripe_product_id"
    t.string "stripe_price_id"
    t.string "stripe_plan_id"
    t.string "status", default: "pending"
    t.index ["user_id"], name: "index_flats_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "state"
    t.string "flat_sku"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "EUR", null: false
    t.string "checkout_session_id"
    t.bigint "user_id", null: false
    t.bigint "flat_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_payment_intent_id"
    t.string "stripe_refund_id"
    t.index ["flat_id"], name: "index_orders_on_flat_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "prices", force: :cascade do |t|
    t.string "stripe_price_id"
    t.string "currency"
    t.boolean "active"
    t.string "metadata"
    t.string "stripe_product_id"
    t.string "nickname"
    t.json "recurring"
    t.integer "price_cents", default: 0, null: false
    t.bigint "flat_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["flat_id"], name: "index_prices_on_flat_id"
  end

  create_table "rents", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.bigint "flat_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "EUR", null: false
    t.string "checkout_session_id"
    t.string "status"
    t.index ["flat_id"], name: "index_rents_on_flat_id"
    t.index ["user_id"], name: "index_rents_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "title"
    t.bigint "flat_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["flat_id"], name: "index_rooms_on_flat_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "stripe_customer_id"
    t.boolean "admin", default: false, null: false
    t.string "stripe_payment_intent_id"
    t.string "uid"
    t.string "provider"
    t.string "access_code"
    t.string "publishable_key"
    t.boolean "subscribed", default: false
    t.string "card_last4"
    t.string "card_exp_month"
    t.string "card_exp_year"
    t.string "card_type"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "flats", "users"
  add_foreign_key "orders", "flats"
  add_foreign_key "orders", "users"
  add_foreign_key "prices", "flats"
  add_foreign_key "rents", "flats"
  add_foreign_key "rents", "users"
  add_foreign_key "rooms", "flats"
end
