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

ActiveRecord::Schema[7.0].define(version: 2023_05_19_202450) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "address"
    t.integer "network"
    t.integer "blockchain"
    t.integer "base_currency"
    t.integer "kind"
    t.json "latest_full_state"
    t.datetime "latest_full_state_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_accounts_on_address"
  end

  create_table "transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "tx_id"
    t.string "from"
    t.string "to"
    t.integer "kind"
    t.integer "blockchain"
    t.integer "network"
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from"], name: "index_transactions_on_from"
    t.index ["time"], name: "index_transactions_on_time"
    t.index ["to"], name: "index_transactions_on_to"
    t.index ["tx_id"], name: "index_transactions_on_tx_id"
  end

end
