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

ActiveRecord::Schema.define(version: 20140905035133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configs", force: true do |t|
    t.text     "adminID"
    t.string   "bankInfo"
    t.text     "defaultCurrency"
    t.text     "email"
    t.decimal  "commRateBuy1"
    t.decimal  "commRateBuy2"
    t.decimal  "commRateBuy3"
    t.decimal  "commRateSell1"
    t.decimal  "commRateSell2"
    t.decimal  "commRateSell3"
    t.text     "adminWalletID"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_types", force: true do |t|
    t.text     "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "transaction_types_id"
    t.text     "walletID"
    t.text     "name"
    t.text     "email"
    t.date     "dob"
    t.decimal  "BTCAmt"
    t.decimal  "BTCtoTWDAmt"
    t.decimal  "CommAmt"
    t.decimal  "CommRate"
    t.datetime "OrderDate"
    t.datetime "moneyReceivedDate"
    t.datetime "BTCreceivedDate"
    t.text     "bankName"
    t.text     "bankAcctNumber"
    t.decimal  "marketBTCtoUSDRate"
    t.decimal  "marketBTCtoRMBRate"
    t.decimal  "marketBTCtoHKDRate"
    t.decimal  "marketBTCtoEURate"
    t.decimal  "fxRateUSDtoTWD"
    t.decimal  "fxRateRMBtoTWD"
    t.decimal  "fxRateHKDtoTWD"
    t.decimal  "fxRateEURtoTWD"
    t.decimal  "bibicoinBTCtoTWD"
    t.boolean  "isComplete"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
