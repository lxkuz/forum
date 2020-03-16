# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_16_171033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "transactions", force: :cascade do |t|
    t.integer "uuid", null: false, comment: "Merchant ID"
    t.string "customer_email", comment: "Customer Email"
    t.string "customer_phone", null: false, comment: "Customer Phone"
    t.decimal "amount", comment: "Transaction amount"
    t.string "type", comment: "Transaction type, used for STI"
    t.integer "status", default: 0, null: false, comment: "Status of transaction"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", null: false, comment: "User role (admin or merchant)"
    t.string "name", comment: "Company name"
    t.decimal "total_transaction_sum", default: "0.0", null: false, comment: "Total income amount"
    t.boolean "activity", default: false, null: false, comment: "Merchant active flag"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
