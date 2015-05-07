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

ActiveRecord::Schema.define(version: 20150430232539) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assemblies", force: :cascade do |t|
    t.date     "date_of_assembly",                                                      null: false
    t.integer  "year",                                                                  null: false
    t.decimal  "produced",                     precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "labor_cost",                   precision: 25, scale: 2,                 null: false
    t.decimal  "other_cost",                   precision: 25, scale: 2
    t.decimal  "material_cost",                precision: 25, scale: 2,                 null: false
    t.string   "info",             limit: 200
    t.integer  "product_id",                                                            null: false
    t.integer  "firm_id",                                                               null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.boolean  "deleted",                                               default: false
  end

  add_index "assemblies", ["firm_id", "product_id"], name: "index_assemblies_on_firm_id_and_product_id", using: :btree
  add_index "assemblies", ["firm_id", "year"], name: "index_assemblies_on_firm_id_and_year", using: :btree
  add_index "assemblies", ["product_id", "year"], name: "index_assemblies_on_product_id_and_year", using: :btree

  create_table "assets", force: :cascade do |t|
    t.string   "asset_type",                                                                  null: false
    t.string   "asset_name",                                                                  null: false
    t.decimal  "unit",                                 precision: 25, scale: 2,               null: false
    t.decimal  "unit_sold",                            precision: 25, scale: 2,               null: false
    t.string   "measurement"
    t.decimal  "value",                                precision: 25, scale: 3,               null: false
    t.decimal  "value_per_unit",                       precision: 25, scale: 3,               null: false
    t.decimal  "useful_life"
    t.decimal  "accumulated_depreciation",             precision: 25, scale: 3, default: 0.0, null: false
    t.decimal  "total_depreciation",                   precision: 25, scale: 3, default: 0.0, null: false
    t.decimal  "depreciation_cost",                    precision: 25, scale: 3, default: 0.0, null: false
    t.string   "status",                   limit: 200
    t.integer  "spending_id",                                                                 null: false
    t.integer  "firm_id",                                                                     null: false
    t.datetime "created_at",                                                                  null: false
    t.datetime "updated_at",                                                                  null: false
  end

  add_index "assets", ["asset_type"], name: "index_assets_on_asset_type", using: :btree
  add_index "assets", ["firm_id", "spending_id"], name: "index_assets_on_firm_id_and_spending_id", using: :btree

  create_table "balance_sheets", force: :cascade do |t|
    t.integer  "year",                                                          null: false
    t.decimal  "cash",                 precision: 25, scale: 2, default: 0.0
    t.decimal  "inventories",          precision: 25, scale: 2, default: 0.0
    t.decimal  "receivables",          precision: 25, scale: 2, default: 0.0
    t.decimal  "prepaids",             precision: 25, scale: 2, default: 0.0
    t.decimal  "supplies",             precision: 25, scale: 2, default: 0.0
    t.decimal  "other_current_assets", precision: 25, scale: 2, default: 0.0
    t.decimal  "fixed_assets",         precision: 25, scale: 2, default: 0.0
    t.decimal  "accu_depr",            precision: 25, scale: 2, default: 0.0
    t.decimal  "other_fixed_assets",   precision: 25, scale: 2, default: 0.0
    t.decimal  "payables",             precision: 25, scale: 2, default: 0.0
    t.decimal  "debts",                precision: 25, scale: 2, default: 0.0
    t.decimal  "retained",             precision: 25, scale: 2, default: 0.0
    t.decimal  "old_retained",         precision: 25, scale: 2, default: 0.0
    t.decimal  "capital",              precision: 25, scale: 2, default: 0.0
    t.decimal  "drawing",              precision: 25, scale: 2, default: 0.0
    t.boolean  "closed",                                        default: false
    t.integer  "firm_id",                                                       null: false
    t.integer  "fiscal_year_id",                                                null: false
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
  end

  add_index "balance_sheets", ["firm_id", "fiscal_year_id"], name: "index_balance_sheets_on_firm_id_and_fiscal_year_id", unique: true, using: :btree
  add_index "balance_sheets", ["firm_id", "year"], name: "index_balance_sheets_on_firm_id_and_year", unique: true, using: :btree
  add_index "balance_sheets", ["firm_id"], name: "index_balance_sheets_on_firm_id", using: :btree

  create_table "bookings", force: :cascade do |t|
    t.date     "date_of_booking", null: false
    t.integer  "year"
    t.string   "input_to",        null: false
    t.string   "message_text",    null: false
    t.text     "contents",        null: false
    t.string   "phone_number",    null: false
    t.integer  "sms_id",          null: false
    t.integer  "user_id",         null: false
    t.integer  "firm_id",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "bookings", ["firm_id", "phone_number"], name: "index_bookings_on_firm_id_and_phone_number", using: :btree
  add_index "bookings", ["firm_id", "user_id"], name: "index_bookings_on_firm_id_and_user_id", using: :btree
  add_index "bookings", ["firm_id", "year"], name: "index_bookings_on_firm_id_and_year", using: :btree
  add_index "bookings", ["id", "firm_id"], name: "index_bookings_on_id_and_firm_id", using: :btree

  create_table "cash_flows", force: :cascade do |t|
    t.integer  "year",                                                        null: false
    t.decimal  "beginning_cash",     precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "net_cash_operating", precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "net_cash_investing", precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "net_cash_financing", precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "net_change",         precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "ending_cash",        precision: 25, scale: 2, default: 0.0,   null: false
    t.boolean  "closed",                                      default: false
    t.integer  "firm_id",                                                     null: false
    t.integer  "fiscal_year_id",                                              null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "cash_flows", ["firm_id", "fiscal_year_id"], name: "index_cash_flows_on_firm_id_and_fiscal_year_id", unique: true, using: :btree
  add_index "cash_flows", ["firm_id", "year"], name: "index_cash_flows_on_firm_id_and_year", unique: true, using: :btree
  add_index "cash_flows", ["firm_id"], name: "index_cash_flows_on_firm_id", using: :btree

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

  create_table "deposits", force: :cascade do |t|
    t.date     "date_granted",                                                                 null: false
    t.integer  "year",                                                                         null: false
    t.integer  "duration",                                                                     null: false
    t.string   "holder",                                                                       null: false
    t.decimal  "amount",                              precision: 25, scale: 2,                 null: false
    t.string   "interest_type",                                                                null: false
    t.decimal  "interest",                            precision: 10, scale: 2,                 null: false
    t.integer  "compound_times_annually",                                      default: 0
    t.date     "maturity",                                                                     null: false
    t.decimal  "interest_balance",                    precision: 25, scale: 2,                 null: false
    t.decimal  "amount_balance",                      precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "total_balance",                       precision: 25, scale: 2, default: 0.0,   null: false
    t.string   "info",                    limit: 200
    t.string   "status",                                                                       null: false
    t.integer  "firm_id",                                                                      null: false
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
    t.boolean  "deleted",                                                      default: false
  end

  add_index "deposits", ["date_granted", "firm_id"], name: "index_deposits_on_date_granted_and_firm_id", using: :btree
  add_index "deposits", ["firm_id", "interest_type"], name: "index_deposits_on_firm_id_and_interest_type", using: :btree

  create_table "discards", force: :cascade do |t|
    t.date     "date_of_write_off",                                                      null: false
    t.integer  "year",                                                                   null: false
    t.decimal  "quantity",                      precision: 25, scale: 2, default: 0.0,   null: false
    t.boolean  "earning",                                                default: false
    t.decimal  "cost_incurred",                 precision: 25
    t.decimal  "item_value",                    precision: 25
    t.string   "info",              limit: 200
    t.integer  "discardable_id"
    t.string   "discardable_type"
    t.integer  "firm_id",                                                                null: false
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.boolean  "deleted",                                                default: false
  end

  add_index "discards", ["firm_id", "discardable_type"], name: "index_discards_on_firm_id_and_discardable_type", using: :btree
  add_index "discards", ["firm_id"], name: "index_discards_on_firm_id", using: :btree
  add_index "discards", ["year", "firm_id"], name: "index_discards_on_year_and_firm_id", using: :btree
  add_index "discards", ["year"], name: "index_discards_on_year", using: :btree

  create_table "expendables", force: :cascade do |t|
    t.string   "account_type",                                            null: false
    t.string   "item_name",                                               null: false
    t.decimal  "unit",           precision: 25, scale: 2,                 null: false
    t.decimal  "unit_expensed",  precision: 25, scale: 2,                 null: false
    t.string   "measurement"
    t.decimal  "value",          precision: 25, scale: 3,                 null: false
    t.decimal  "value_per_unit", precision: 25, scale: 3,                 null: false
    t.decimal  "value_expensed", precision: 25, scale: 3,                 null: false
    t.boolean  "perishable",                              default: false
    t.date     "expiration"
    t.boolean  "perished",                                default: false
    t.integer  "spending_id",                                             null: false
    t.integer  "firm_id",                                                 null: false
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  add_index "expendables", ["firm_id", "account_type"], name: "index_expendables_on_firm_id_and_account_type", using: :btree
  add_index "expendables", ["firm_id", "spending_id"], name: "index_expendables_on_firm_id_and_spending_id", using: :btree

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
    t.string   "name",                              null: false
    t.string   "type",                              null: false
    t.string   "industry",                          null: false
    t.string   "registration_code"
    t.text     "description"
    t.string   "starter_email"
    t.string   "starter_phone"
    t.datetime "last_active",                       null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "deleted",           default: false
  end

  add_index "firms", ["industry"], name: "index_firms_on_industry", using: :btree
  add_index "firms", ["registration_code"], name: "index_firms_on_registration_code", unique: true, using: :btree
  add_index "firms", ["type"], name: "index_firms_on_type", using: :btree

  create_table "fiscal_years", force: :cascade do |t|
    t.integer  "current_year", null: false
    t.date     "beginning",    null: false
    t.date     "ending",       null: false
    t.integer  "prev_year",    null: false
    t.integer  "next_year",    null: false
    t.string   "status",       null: false
    t.integer  "firm_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "fiscal_years", ["current_year", "firm_id"], name: "index_fiscal_years_on_current_year_and_firm_id", unique: true, using: :btree
  add_index "fiscal_years", ["next_year", "firm_id"], name: "index_fiscal_years_on_next_year_and_firm_id", unique: true, using: :btree
  add_index "fiscal_years", ["prev_year", "firm_id"], name: "index_fiscal_years_on_prev_year_and_firm_id", unique: true, using: :btree

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
    t.date     "date_granted",                                                      null: false
    t.integer  "year",                                                              null: false
    t.string   "type",                                                              null: false
    t.string   "contributor",                                                       null: false
    t.decimal  "amount",                   precision: 25, scale: 2,                 null: false
    t.decimal  "ownership",                precision: 5,  scale: 2
    t.string   "info",         limit: 200
    t.integer  "firm_id",                                                           null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.boolean  "deleted",                                           default: false
  end

  add_index "funds", ["date_granted", "firm_id"], name: "index_funds_on_date_granted_and_firm_id", using: :btree
  add_index "funds", ["firm_id", "type"], name: "index_funds_on_firm_id_and_type", using: :btree
  add_index "funds", ["firm_id", "year"], name: "index_funds_on_firm_id_and_year", using: :btree

  create_table "income_statements", force: :cascade do |t|
    t.integer  "year",                                                              null: false
    t.decimal  "revenue",                  precision: 25, scale: 2, default: 0.0
    t.decimal  "cost_of_revenue",          precision: 25, scale: 2, default: 0.0
    t.decimal  "operating_expense",        precision: 25, scale: 2, default: 0.0
    t.decimal  "depreciation_expense",     precision: 25, scale: 2, default: 0.0
    t.decimal  "old_depreciation_expense", precision: 25, scale: 2, default: 0.0
    t.decimal  "other_revenue",            precision: 25, scale: 2, default: 0.0
    t.decimal  "other_expense",            precision: 25, scale: 2, default: 0.0
    t.decimal  "interest_expense",         precision: 25, scale: 2, default: 0.0
    t.decimal  "tax_expense",              precision: 25, scale: 2, default: 0.0
    t.decimal  "net_income",               precision: 25, scale: 2, default: 0.0
    t.decimal  "dividend",                 precision: 25, scale: 2, default: 0.0
    t.decimal  "retained_earning",         precision: 25, scale: 2, default: 0.0
    t.boolean  "closed",                                            default: false
    t.integer  "firm_id",                                                           null: false
    t.integer  "fiscal_year_id",                                                    null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  add_index "income_statements", ["firm_id", "fiscal_year_id"], name: "index_income_statements_on_firm_id_and_fiscal_year_id", unique: true, using: :btree
  add_index "income_statements", ["firm_id", "year"], name: "index_income_statements_on_firm_id_and_year", unique: true, using: :btree
  add_index "income_statements", ["firm_id"], name: "index_income_statements_on_firm_id", using: :btree

  create_table "loans", force: :cascade do |t|
    t.date     "date_granted",                                                                 null: false
    t.integer  "year",                                                                         null: false
    t.integer  "duration",                                                                     null: false
    t.string   "type",                                                                         null: false
    t.string   "contributor",                                                                  null: false
    t.decimal  "amount",                              precision: 25, scale: 2,                 null: false
    t.string   "interest_type",                                                                null: false
    t.decimal  "monthly_interest",                    precision: 10, scale: 2,                 null: false
    t.integer  "compound_times_annually",                                      default: 0
    t.date     "maturity",                                                                     null: false
    t.decimal  "interest_balance",                    precision: 25, scale: 2,                 null: false
    t.decimal  "amount_balance",                      precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "total_balance",                       precision: 25, scale: 2, default: 0.0,   null: false
    t.string   "info",                    limit: 200
    t.string   "status",                                                                       null: false
    t.integer  "asset_id"
    t.integer  "firm_id",                                                                      null: false
    t.datetime "created_at",                                                                   null: false
    t.datetime "updated_at",                                                                   null: false
    t.boolean  "deleted",                                                      default: false
  end

  add_index "loans", ["date_granted", "firm_id"], name: "index_loans_on_date_granted_and_firm_id", using: :btree
  add_index "loans", ["firm_id", "interest_type"], name: "index_loans_on_firm_id_and_interest_type", using: :btree
  add_index "loans", ["firm_id", "type"], name: "index_loans_on_firm_id_and_type", using: :btree
  add_index "loans", ["firm_id", "year"], name: "index_loans_on_firm_id_and_year", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "material_name",                                                     null: false
    t.decimal  "quantity",                   precision: 25, scale: 2,               null: false
    t.decimal  "quantity_used",              precision: 25, scale: 2, default: 0.0, null: false
    t.string   "measurement"
    t.decimal  "cost",                       precision: 25, scale: 2,               null: false
    t.decimal  "cost_per_unit",              precision: 25, scale: 2,               null: false
    t.decimal  "cost_used",                  precision: 25, scale: 2, default: 0.0, null: false
    t.decimal  "cost_remaining",             precision: 25, scale: 2,               null: false
    t.string   "status",         limit: 200
    t.integer  "spending_id",                                                       null: false
    t.integer  "firm_id",                                                           null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
  end

  add_index "materials", ["firm_id", "spending_id"], name: "index_materials_on_firm_id_and_spending_id", using: :btree
  add_index "materials", ["firm_id"], name: "index_materials_on_firm_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "firm_id",    null: false
    t.string   "role"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["firm_id", "role"], name: "index_memberships_on_firm_id_and_role", using: :btree
  add_index "memberships", ["user_id", "firm_id"], name: "index_memberships_on_user_id_and_firm_id", unique: true, using: :btree
  add_index "memberships", ["user_id", "role"], name: "index_memberships_on_user_id_and_role", using: :btree

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

  create_table "other_revenues", force: :cascade do |t|
    t.date     "date_of_revenue",                                                      null: false
    t.integer  "year",                                                                 null: false
    t.string   "source",          limit: 60,                                           null: false
    t.decimal  "total_earned",                precision: 25,                           null: false
    t.boolean  "installment",                                          default: false
    t.decimal  "dp_received",                 precision: 25
    t.decimal  "discount",                    precision: 25, scale: 2
    t.date     "maturity"
    t.string   "info",            limit: 200
    t.integer  "firm_id",                                                              null: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.boolean  "deleted",                                              default: false
  end

  add_index "other_revenues", ["date_of_revenue", "firm_id"], name: "index_other_revenues_on_date_of_revenue_and_firm_id", using: :btree
  add_index "other_revenues", ["firm_id", "source"], name: "index_other_revenues_on_firm_id_and_source", using: :btree
  add_index "other_revenues", ["firm_id"], name: "index_other_revenues_on_firm_id", using: :btree
  add_index "other_revenues", ["year"], name: "index_other_revenues_on_year", using: :btree

  create_table "payable_payments", force: :cascade do |t|
    t.date     "date_of_payment",                                                       null: false
    t.integer  "year",                                                                  null: false
    t.decimal  "amount",                       precision: 25, scale: 2,                 null: false
    t.decimal  "interest_payment",             precision: 25, scale: 2
    t.string   "info",             limit: 200
    t.integer  "payable_id"
    t.string   "payable_type"
    t.integer  "firm_id",                                                               null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.boolean  "deleted",                                               default: false
  end

  add_index "payable_payments", ["firm_id", "payable_id"], name: "index_payable_payments_on_firm_id_and_payable_id", using: :btree
  add_index "payable_payments", ["firm_id", "payable_type"], name: "index_payable_payments_on_firm_id_and_payable_type", using: :btree
  add_index "payable_payments", ["year", "firm_id"], name: "index_payable_payments_on_year_and_firm_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.string   "payment_code",                    null: false
    t.integer  "total_payment"
    t.integer  "subscription_id",                 null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "deleted",         default: false
  end

  add_index "payments", ["subscription_id", "payment_code"], name: "index_payments_on_subscription_id_and_payment_code", unique: true, using: :btree
  add_index "payments", ["subscription_id"], name: "index_payments_on_subscription_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",        null: false
    t.decimal  "price",       null: false
    t.integer  "duration",    null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

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

  create_table "processings", force: :cascade do |t|
    t.decimal  "quantity_used", precision: 25, scale: 2,                 null: false
    t.decimal  "cost_used",     precision: 25, scale: 2,                 null: false
    t.integer  "material_id",                                            null: false
    t.integer  "assembly_id",                                            null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.boolean  "deleted",                                default: false
  end

  add_index "processings", ["assembly_id", "material_id"], name: "index_processings_on_assembly_id_and_material_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "product_name",                                                           null: false
    t.integer  "hour_needed",                                            default: 0
    t.decimal  "quantity_produced",             precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "quantity_sold",                 precision: 25, scale: 2, default: 0.0,   null: false
    t.string   "measurement"
    t.decimal  "cost",                          precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "cost_sold",                     precision: 25, scale: 2, default: 0.0,   null: false
    t.string   "status",            limit: 200
    t.integer  "firm_id",                                                                null: false
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.boolean  "deleted",                                                default: false
  end

  add_index "products", ["firm_id"], name: "index_products_on_firm_id", using: :btree

  create_table "receivable_payments", force: :cascade do |t|
    t.date     "date_of_payment",                                                      null: false
    t.integer  "year",                                                                 null: false
    t.decimal  "amount",                      precision: 25, scale: 2,                 null: false
    t.decimal  "discount_amount",             precision: 25, scale: 2
    t.string   "info",            limit: 200
    t.integer  "firm_id",                                                              null: false
    t.integer  "revenue_id",                                                           null: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.boolean  "deleted",                                              default: false
  end

  add_index "receivable_payments", ["date_of_payment", "firm_id"], name: "index_receivable_payments_on_date_of_payment_and_firm_id", using: :btree
  add_index "receivable_payments", ["firm_id", "revenue_id"], name: "index_receivable_payments_on_firm_id_and_revenue_id", using: :btree
  add_index "receivable_payments", ["year", "firm_id"], name: "index_receivable_payments_on_year_and_firm_id", using: :btree

  create_table "revenues", force: :cascade do |t|
    t.date     "date_of_revenue",                                                      null: false
    t.integer  "year",                                                                 null: false
    t.decimal  "quantity",                    precision: 25, scale: 2, default: 0.0,   null: false
    t.decimal  "total_earned",                precision: 25,                           null: false
    t.boolean  "installment",                                          default: false
    t.decimal  "dp_received",                 precision: 25
    t.decimal  "payment_balance",             precision: 25, scale: 2, default: 0.0
    t.decimal  "discount",                    precision: 25, scale: 2
    t.date     "maturity"
    t.string   "info",            limit: 100
    t.decimal  "item_value",                  precision: 25, scale: 2,                 null: false
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "firm_id",                                                              null: false
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.boolean  "deleted",                                              default: false
  end

  add_index "revenues", ["date_of_revenue", "firm_id"], name: "index_revenues_on_date_of_revenue_and_firm_id", using: :btree
  add_index "revenues", ["firm_id", "item_type"], name: "index_revenues_on_firm_id_and_item_type", using: :btree
  add_index "revenues", ["firm_id"], name: "index_revenues_on_firm_id", using: :btree
  add_index "revenues", ["year"], name: "index_revenues_on_year", using: :btree

  create_table "spendings", force: :cascade do |t|
    t.date     "date_of_spending",                                                      null: false
    t.integer  "year",                                                                  null: false
    t.string   "spending_type",                                                         null: false
    t.decimal  "total_spent",                  precision: 25,                           null: false
    t.boolean  "installment",                                           default: false
    t.decimal  "dp_paid",                      precision: 25, scale: 2
    t.decimal  "payment_balance",              precision: 25, scale: 2, default: 0.0
    t.decimal  "discount",                     precision: 25, scale: 2
    t.date     "maturity"
    t.string   "info",             limit: 200
    t.integer  "firm_id",                                                               null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.boolean  "deleted",                                               default: false
  end

  add_index "spendings", ["date_of_spending", "firm_id"], name: "index_spendings_on_date_of_spending_and_firm_id", using: :btree
  add_index "spendings", ["firm_id", "spending_type"], name: "index_spendings_on_firm_id_and_spending_type", using: :btree
  add_index "spendings", ["firm_id"], name: "index_spendings_on_firm_id", using: :btree
  add_index "spendings", ["year"], name: "index_spendings_on_year", using: :btree

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subscribers", ["email"], name: "index_subscribers_on_email", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "plan_id",    null: false
    t.integer  "user_id",    null: false
    t.string   "status",     null: false
    t.date     "start",      null: false
    t.date     "end",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "subscriptions", ["plan_id", "user_id"], name: "index_subscriptions_on_plan_id_and_user_id", using: :btree
  add_index "subscriptions", ["plan_id"], name: "index_subscriptions_on_plan_id", using: :btree
  add_index "subscriptions", ["status"], name: "index_subscriptions_on_status", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

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
    t.string   "full_name",                              null: false
    t.string   "phone_number",                           null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["full_name", "phone_number"], name: "index_users_on_full_name_and_phone_number", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "works", force: :cascade do |t|
    t.string   "work_name",                  null: false
    t.integer  "tally"
    t.integer  "firm_id",                    null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "deleted",    default: false
  end

  add_index "works", ["firm_id"], name: "index_works_on_firm_id", using: :btree

end
