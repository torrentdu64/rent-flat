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

ActiveRecord::Schema.define(version: 2021_12_31_023947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "copmanies", force: :cascade do |t|
    t.string "name"
    t.string "address_line1"
    t.string "address_postal_code"
    t.string "address_city"
    t.string "phone"
    t.string "tax_id"
    t.boolean "executives_provided"
    t.boolean "owners_provided"
    t.string "mcc"
    t.bigint "stripe_account_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stripe_account_id"], name: "index_copmanies_on_stripe_account_id"
  end

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

  create_table "stripe_accounts", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "account_type"
    t.integer "dob_month"
    t.integer "dob_day"
    t.integer "dob_year"
    t.string "address_city"
    t.string "address_state"
    t.string "address_line1"
    t.string "address_postal"
    t.boolean "tos"
    t.string "ssn_last_4"
    t.string "business_name"
    t.string "business_tax_id"
    t.string "personal_id_number"
    t.string "verification_document"
    t.string "acct_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "country"
    t.string "currency"
    t.string "routing_number"
    t.string "account_number"
    t.boolean "charges_enabled", default: false
    t.index ["user_id"], name: "index_stripe_accounts_on_user_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "copmanies", "stripe_accounts"
  add_foreign_key "flats", "users"
  add_foreign_key "orders", "flats"
  add_foreign_key "orders", "users"
  add_foreign_key "prices", "flats"
  add_foreign_key "rents", "flats"
  add_foreign_key "rents", "users"
  add_foreign_key "rooms", "flats"
  add_foreign_key "stripe_accounts", "users"
end
