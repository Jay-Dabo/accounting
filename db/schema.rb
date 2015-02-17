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

ActiveRecord::Schema.define(version: 20150215092541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assets", force: :cascade do |t|
    t.date     "date_of_acquisition"
    t.string   "name",                                                                     null: false
    t.string   "type"
    t.decimal  "acquiring_cost",                  precision: 15, scale: 2, default: 0.0,   null: false
    t.boolean  "full_payment",                                             default: false
    t.decimal  "down_payment",                    precision: 15, scale: 2, default: 0.0
    t.date     "maturity"
    t.string   "info",                limit: 200
    t.integer  "firm_id"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
  end

  add_index "assets", ["firm_id"], name: "index_assets_on_firm_id", using: :btree
  add_index "assets", ["type", "firm_id"], name: "index_assets_on_type_and_firm_id", using: :btree
  add_index "assets", ["type"], name: "index_assets_on_type", using: :btree

  create_table "balance_sheets", force: :cascade do |t|
    t.integer  "year",                                                    null: false
    t.decimal  "cash",             precision: 15, scale: 2, default: 0.0
    t.decimal  "temp_investments", precision: 15, scale: 2, default: 0.0
    t.decimal  "inventories",      precision: 15, scale: 2, default: 0.0
    t.decimal  "receivables",      precision: 15, scale: 2, default: 0.0
    t.decimal  "supplies",         precision: 15, scale: 2, default: 0.0
    t.decimal  "prepaids",         precision: 15, scale: 2, default: 0.0
    t.decimal  "fixed_assets",     precision: 15, scale: 2, default: 0.0
    t.decimal  "investments",      precision: 15, scale: 2, default: 0.0
    t.decimal  "intangibles",      precision: 15, scale: 2, default: 0.0
    t.decimal  "payables",         precision: 15, scale: 2, default: 0.0
    t.decimal  "debts",            precision: 15, scale: 2, default: 0.0
    t.decimal  "retained",         precision: 15, scale: 2, default: 0.0
    t.decimal  "capital",          precision: 15, scale: 2, default: 0.0
    t.decimal  "drawing",          precision: 15, scale: 2, default: 0.0
    t.integer  "firm_id",                                                 null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "balance_sheets", ["firm_id", "year"], name: "index_balance_sheets_on_firm_id_and_year", unique: true, using: :btree
  add_index "balance_sheets", ["firm_id"], name: "index_balance_sheets_on_firm_id", using: :btree
  add_index "balance_sheets", ["year"], name: "index_balance_sheets_on_year", using: :btree

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
    t.date     "date_of_expense",                                                     null: false
    t.string   "item",                                                                null: false
    t.integer  "unit"
    t.decimal  "total_expense",                                        default: 0.0,  null: false
    t.boolean  "full_payment",                                         default: true
    t.decimal  "down_payment",                precision: 15, scale: 2, default: 0.0
    t.date     "maturity"
    t.string   "info",            limit: 200
    t.integer  "firm_id"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
  end

  add_index "expenses", ["date_of_expense", "firm_id"], name: "index_expenses_on_date_of_expense_and_firm_id", using: :btree
  add_index "expenses", ["date_of_expense"], name: "index_expenses_on_date_of_expense", using: :btree
  add_index "expenses", ["firm_id"], name: "index_expenses_on_firm_id", using: :btree

  create_table "firms", force: :cascade do |t|
    t.string   "name",          null: false
    t.string   "business_type", null: false
    t.string   "industry",      null: false
    t.integer  "user_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "firms", ["business_type"], name: "index_firms_on_business_type", using: :btree
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
    t.date     "date_granted",                                          null: false
    t.boolean  "loan",                                  default: false
    t.string   "contributor",                                           null: false
    t.decimal  "amount",       precision: 15, scale: 2, default: 0.0,   null: false
    t.decimal  "interest",                              default: 0.0
    t.date     "maturity"
    t.decimal  "ownership",                             default: 0.0
    t.integer  "firm_id"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  add_index "funds", ["date_granted", "firm_id"], name: "index_funds_on_date_granted_and_firm_id", using: :btree
  add_index "funds", ["date_granted"], name: "index_funds_on_date_granted", using: :btree
  add_index "funds", ["firm_id"], name: "index_funds_on_firm_id", using: :btree

  create_table "income_statements", force: :cascade do |t|
    t.integer  "year",                                                      null: false
    t.decimal  "sales",              precision: 15, scale: 2, default: 0.0
    t.decimal  "cogs",               precision: 15, scale: 2, default: 0.0
    t.decimal  "operating_expenses", precision: 15, scale: 2, default: 0.0
    t.decimal  "interest_expenses",  precision: 15, scale: 2, default: 0.0
    t.decimal  "tax_expenses",       precision: 15, scale: 2, default: 0.0
    t.decimal  "net_income",         precision: 15, scale: 2, default: 0.0
    t.decimal  "dividends",          precision: 15, scale: 2, default: 0.0
    t.decimal  "retained_earnings",  precision: 15, scale: 2, default: 0.0
    t.integer  "firm_id",                                                   null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
  end

  add_index "income_statements", ["firm_id", "year"], name: "index_income_statements_on_firm_id_and_year", unique: true, using: :btree
  add_index "income_statements", ["firm_id"], name: "index_income_statements_on_firm_id", using: :btree
  add_index "income_statements", ["year"], name: "index_income_statements_on_year", using: :btree

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

  create_table "purchases", force: :cascade do |t|
    t.date     "date_of_purchase",                                                     null: false
    t.string   "source",           limit: 200
    t.string   "item",                                                                 null: false
    t.integer  "unit",                                                  default: 1,    null: false
    t.decimal  "total_purchased",                                       default: 0.0,  null: false
    t.boolean  "full_payment",                                          default: true
    t.decimal  "down_payment",                 precision: 15, scale: 2, default: 0.0
    t.date     "maturity"
    t.string   "info",             limit: 200
    t.integer  "firm_id"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
  end

  add_index "purchases", ["date_of_purchase", "firm_id"], name: "index_purchases_on_date_of_purchase_and_firm_id", using: :btree
  add_index "purchases", ["date_of_purchase"], name: "index_purchases_on_date_of_purchase", using: :btree
  add_index "purchases", ["firm_id"], name: "index_purchases_on_firm_id", using: :btree

  create_table "sales", force: :cascade do |t|
    t.date     "date_of_sale",                                                     null: false
    t.string   "item",                                                             null: false
    t.integer  "unit",                                                             null: false
    t.decimal  "total_earned",                                      default: 0.0,  null: false
    t.boolean  "full_payment",                                      default: true
    t.decimal  "down_payment",             precision: 15, scale: 2, default: 0.0
    t.date     "maturity"
    t.string   "info",         limit: 200
    t.integer  "firm_id"
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "sales", ["date_of_sale", "firm_id"], name: "index_sales_on_date_of_sale_and_firm_id", using: :btree
  add_index "sales", ["date_of_sale"], name: "index_sales_on_date_of_sale", using: :btree
  add_index "sales", ["firm_id"], name: "index_sales_on_firm_id", using: :btree

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
