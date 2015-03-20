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

ActiveRecord::Schema.define(version: 20150314083756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.string   "asset_type",                                                                  null: false
    t.string   "asset_name",                                                                  null: false
    t.decimal  "unit",                                 precision: 25, scale: 2,               null: false
    t.decimal  "unit_sold",                            precision: 25, scale: 2,               null: false
    t.string   "measurement"
    t.decimal  "value",                                precision: 25, scale: 3,               null: false
    t.decimal  "value_per_unit",                       precision: 25, scale: 3,               null: false
    t.decimal  "useful_life"
    t.decimal  "depreciation_cost",                    precision: 25, scale: 3, default: 0.0, null: false
    t.decimal  "accumulated_depreciation",             precision: 25, scale: 3, default: 0.0, null: false
    t.string   "status",                   limit: 200
    t.integer  "spending_id",                                                                 null: false
    t.integer  "firm_id",                                                                     null: false
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
  end

  add_index "assets", ["asset_type"], name: "index_assets_on_asset_type", using: :btree
  add_index "assets", ["firm_id", "spending_id"], name: "index_assets_on_firm_id_and_spending_id", using: :btree

  create_table "balance_sheets", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "year",                                          null: false
    t.integer  "cash_sens",                     default: 0,     null: false
    t.string   "cash_currency",                 default: "IDR", null: false
    t.integer  "inventories_sens",              default: 0,     null: false
    t.string   "inventories_currency",          default: "IDR", null: false
    t.integer  "receivables_sens",              default: 0,     null: false
    t.string   "receivables_currency",          default: "IDR", null: false
    t.integer  "other_current_assets_sens",     default: 0,     null: false
    t.string   "other_current_assets_currency", default: "IDR", null: false
    t.integer  "fixed_assets_sens",             default: 0,     null: false
    t.string   "fixed_assets_currency",         default: "IDR", null: false
    t.integer  "accumulated_depr_sens",         default: 0,     null: false
    t.string   "accumulated_depr_currency",     default: "IDR", null: false
    t.integer  "other_fixed_assets_sens",       default: 0,     null: false
    t.string   "other_fixed_assets_currency",   default: "IDR", null: false
    t.integer  "payables_sens",                 default: 0,     null: false
    t.string   "payables_currency",             default: "IDR", null: false
    t.integer  "debts_sens",                    default: 0,     null: false
    t.string   "debts_currency",                default: "IDR", null: false
    t.integer  "retained_sens",                 default: 0,     null: false
    t.string   "retained_currency",             default: "IDR", null: false
    t.integer  "capital_sens",                  default: 0,     null: false
    t.string   "capital_currency",              default: "IDR", null: false
    t.integer  "drawing_sens",                  default: 0,     null: false
    t.string   "drawing_currency",              default: "IDR", null: false
    t.boolean  "closed",                        default: false
    t.integer  "firm_id",                                       null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "balance_sheets", ["firm_id", "year"], name: "index_balance_sheets_on_firm_id_and_year", unique: true, using: :btree
  add_index "balance_sheets", ["firm_id"], name: "index_balance_sheets_on_firm_id", using: :btree
  add_index "balance_sheets", ["year"], name: "index_balance_sheets_on_year", using: :btree

  create_table "cash_flows", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "year",                                                        null: false
    t.decimal  "beginning_cash",     precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "net_cash_operating", precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "net_cash_investing", precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "net_cash_financing", precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "net_change",         precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "ending_cash",        precision: 25, scale: 2, default: 0.0,   null: false
    t.boolean  "closed",                                      default: false
    t.integer  "firm_id",                                                     null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "cash_flows", ["firm_id", "year"], name: "index_cash_flows_on_firm_id_and_year", unique: true, using: :btree
  add_index "cash_flows", ["firm_id"], name: "index_cash_flows_on_firm_id", using: :btree
  add_index "cash_flows", ["year"], name: "index_cash_flows_on_year", using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "expenses", force: :cascade do |t|
    t.string   "expense_type",                                       null: false
    t.string   "expense_name",                          default: ""
    t.decimal  "quantity",     precision: 25, scale: 2,              null: false
    t.string   "measurement"
    t.decimal  "cost",         precision: 25,                        null: false
    t.integer  "spending_id",                                        null: false
    t.integer  "firm_id",                                            null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "expenses", ["expense_type"], name: "index_expenses_on_expense_type", using: :btree
  add_index "expenses", ["firm_id", "spending_id"], name: "index_expenses_on_firm_id_and_spending_id", using: :btree

  create_table "firms", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "type",       null: false
    t.string   "industry",   null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "firms", ["type", "user_id"], name: "index_firms_on_type_and_user_id", using: :btree
  add_index "firms", ["type"], name: "index_firms_on_type", using: :btree
  add_index "firms", ["user_id"], name: "index_firms_on_user_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "funds", force: :cascade do |t|
    t.date     "date_granted",                                      null: false
    t.string   "type",                                              null: false
    t.string   "contributor",                                       null: false
    t.decimal  "amount",                   precision: 25, scale: 2, null: false
    t.decimal  "ownership",                precision: 5,  scale: 2
    t.string   "info",         limit: 200
    t.integer  "firm_id",                                           null: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "funds", ["date_granted", "firm_id"], name: "index_funds_on_date_granted_and_firm_id", using: :btree
  add_index "funds", ["firm_id", "type"], name: "index_funds_on_firm_id_and_type", using: :btree

  create_table "income_statements", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "year",                                       null: false
    t.integer  "revenue_sens",               default: 0,     null: false
    t.string   "revenue_currency",           default: "IDR", null: false
    t.integer  "cost_of_revenue_sens",       default: 0,     null: false
    t.string   "cost_of_revenue_currency",   default: "IDR", null: false
    t.integer  "operating_expense_sens",     default: 0,     null: false
    t.string   "operating_expense_currency", default: "IDR", null: false
    t.integer  "other_revenue_sens",         default: 0,     null: false
    t.string   "other_revenue_currency",     default: "IDR", null: false
    t.integer  "other_expense_sens",         default: 0,     null: false
    t.string   "other_expense_currency",     default: "IDR", null: false
    t.integer  "interest_expense_sens",      default: 0,     null: false
    t.string   "interest_expense_currency",  default: "IDR", null: false
    t.integer  "tax_expense_sens",           default: 0,     null: false
    t.string   "tax_expense_currency",       default: "IDR", null: false
    t.integer  "net_income_sens",            default: 0,     null: false
    t.string   "net_income_currency",        default: "IDR", null: false
    t.integer  "dividend_sens",              default: 0,     null: false
    t.string   "dividend_currency",          default: "IDR", null: false
    t.integer  "retained_earning_sens",      default: 0,     null: false
    t.string   "retained_earning_currency",  default: "IDR", null: false
    t.boolean  "locked",                     default: false
    t.integer  "firm_id",                                    null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "income_statements", ["firm_id", "year"], name: "index_income_statements_on_firm_id_and_year", unique: true, using: :btree
  add_index "income_statements", ["firm_id"], name: "index_income_statements_on_firm_id", using: :btree
  add_index "income_statements", ["year"], name: "index_income_statements_on_year", using: :btree

  create_table "loans", force: :cascade do |t|
    t.date     "date_granted",                                                        null: false
    t.string   "type",                                                                null: false
    t.string   "contributor",                                                         null: false
    t.decimal  "amount",                       precision: 25, scale: 2,               null: false
    t.decimal  "interest",                     precision: 10, scale: 2,               null: false
    t.date     "maturity",                                                            null: false
    t.decimal  "interest_balance",             precision: 25, scale: 2,               null: false
    t.decimal  "amount_balance",               precision: 25, scale: 2, default: 0.0, null: false
    t.string   "info",             limit: 200
    t.integer  "asset_id"
    t.integer  "firm_id",                                                             null: false
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
  end

  add_index "loans", ["date_granted", "firm_id"], name: "index_loans_on_date_granted_and_firm_id", using: :btree
  add_index "loans", ["firm_id", "asset_id"], name: "index_loans_on_firm_id_and_asset_id", using: :btree
  add_index "loans", ["firm_id", "type"], name: "index_loans_on_firm_id_and_type", using: :btree

  create_table "merchandises", force: :cascade do |t|
    t.string   "merch_name",                                          default: "", null: false
    t.decimal  "quantity",                   precision: 25, scale: 2,              null: false
    t.decimal  "quantity_sold",              precision: 25, scale: 2,              null: false
    t.string   "measurement"
    t.decimal  "cost",                       precision: 25, scale: 2,              null: false
    t.decimal  "cost_per_unit",              precision: 25, scale: 2,              null: false
    t.decimal  "cost_sold",                  precision: 25, scale: 2,              null: false
    t.decimal  "cost_remaining",             precision: 25, scale: 2,              null: false
    t.decimal  "price",                      precision: 25, scale: 2,              null: false
    t.string   "status",         limit: 200
    t.integer  "spending_id",                                                      null: false
    t.integer  "firm_id",                                                          null: false
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "merchandises", ["firm_id", "spending_id"], name: "index_merchandises_on_firm_id_and_spending_id", using: :btree
  add_index "merchandises", ["merch_name"], name: "index_merchandises_on_merch_name", using: :btree

  create_table "payable_payments", force: :cascade do |t|
    t.date     "date_of_payment",                                      null: false
    t.decimal  "amount",                      precision: 25, scale: 2, null: false
    t.string   "info",            limit: 200
    t.integer  "payable_id"
    t.string   "payable_type"
    t.integer  "firm_id",                                              null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "payable_payments", ["date_of_payment", "firm_id"], name: "index_payable_payments_on_date_of_payment_and_firm_id", using: :btree
  add_index "payable_payments", ["firm_id", "payable_id"], name: "index_payable_payments_on_firm_id_and_payable_id", using: :btree
  add_index "payable_payments", ["firm_id", "payable_type"], name: "index_payable_payments_on_firm_id_and_payable_type", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "content_md"
    t.text     "content_html"
    t.boolean  "draft",        default: false
    t.integer  "user_id"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "receivable_payments", force: :cascade do |t|
    t.date     "date_of_payment",                                      null: false
    t.decimal  "amount",                      precision: 25, scale: 2, null: false
    t.string   "info",            limit: 200
    t.integer  "firm_id",                                              null: false
    t.integer  "revenue_id",                                           null: false
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "receivable_payments", ["date_of_payment", "firm_id"], name: "index_receivable_payments_on_date_of_payment_and_firm_id", using: :btree
  add_index "receivable_payments", ["firm_id", "revenue_id"], name: "index_receivable_payments_on_firm_id_and_revenue_id", using: :btree

  create_table "revenues", force: :cascade do |t|
    t.date     "date_of_revenue",                                                      null: false
    t.decimal  "quantity",                    precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "total_earned",                precision: 25,                           null: false
    t.boolean  "installment",                                          default: false
    t.decimal  "dp_received",                 precision: 25
    t.decimal  "interest",                    precision: 15, scale: 2
    t.date     "maturity"
    t.string   "info",            limit: 100
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "firm_id",                                                              null: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
  end

  add_index "revenues", ["date_of_revenue", "firm_id"], name: "index_revenues_on_date_of_revenue_and_firm_id", using: :btree
  add_index "revenues", ["date_of_revenue"], name: "index_revenues_on_date_of_revenue", using: :btree
  add_index "revenues", ["firm_id", "item_type"], name: "index_revenues_on_firm_id_and_item_type", using: :btree
  add_index "revenues", ["firm_id"], name: "index_revenues_on_firm_id", using: :btree

  create_table "spendings", force: :cascade do |t|
    t.date     "date_of_spending",                                                      null: false
    t.string   "spending_type",                                                         null: false
    t.decimal  "total_spent",                  precision: 25,                           null: false
    t.boolean  "installment",                                           default: false
    t.decimal  "dp_paid",                      precision: 25, scale: 2
    t.decimal  "interest",                     precision: 25, scale: 2
    t.date     "maturity"
    t.string   "info",             limit: 200
    t.integer  "firm_id",                                                               null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "spendings", ["date_of_spending", "firm_id"], name: "index_spendings_on_date_of_spending_and_firm_id", using: :btree
  add_index "spendings", ["date_of_spending"], name: "index_spendings_on_date_of_spending", using: :btree
  add_index "spendings", ["firm_id", "spending_type"], name: "index_spendings_on_firm_id_and_spending_type", using: :btree
  add_index "spendings", ["firm_id"], name: "index_spendings_on_firm_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.boolean  "admin",                  default: false, null: false
    t.boolean  "locked",                 default: false, null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
