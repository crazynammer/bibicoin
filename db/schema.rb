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

ActiveRecord::Schema.define(version: 20140901234131) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configs", force: true do |t|
    t.text     "adminID"
    t.string   "bankinfo"
    t.text     "defaultcurrency"
    t.text     "email"
    t.decimal  "commratebuy1"
    t.decimal  "commratebuy2"
    t.decimal  "commratebuy3"
    t.decimal  "commratesell1"
    t.decimal  "commratesell2"
    t.decimal  "commratesell3"
    t.integer  "refreshinternval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fx_rates", force: true do |t|
    t.decimal  "marketBTCtoUSDRate"
    t.decimal  "marketBTCtoRMBRate"
    t.decimal  "marketBTCtoHKDRate"
    t.decimal  "marketBTCtoEURRate"
    t.decimal  "fxRateUSDtoTWD"
    t.decimal  "fxRateRMBtoTWD"
    t.decimal  "fxRateEURtoTWD"
    t.decimal  "bibicoinBTCtoTWD"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_types", force: true do |t|
    t.text     "type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.text     "walletid"
    t.text     "name"
    t.text     "email"
    t.date     "dob"
    t.decimal  "BTCamt"
    t.decimal  "BTCweightedfxrate"
    t.decimal  "BTCtoNTDamt"
    t.decimal  "commAmt"
    t.decimal  "commrate"
    t.datetime "orderdate"
    t.datetime "moneyreceiveddate"
    t.datetime "BTCreceievedDate"
    t.text     "bankname"
    t.integer  "bankacctnumber"
    t.boolean  "isComplete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_types_id"
  end

end
