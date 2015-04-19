class CreateFundsAndLoans < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.date     :date_granted, null: false
      t.integer  :year, null: false
      t.string   :type, null: false
      t.string   :contributor, null: false
      t.decimal  :amount, precision: 25, scale: 2, null: false
      t.decimal  :ownership, precision: 5, scale: 2
      t.string   :info, :limit => 200
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :funds, [:date_granted, :firm_id]
    add_index :funds, [:firm_id, :year]
    add_index :funds, [:firm_id, :type]

    create_table :loans do |t|
      t.date     :date_granted, null: false
      t.integer  :year, null: false
      t.integer  :duration, null: false
      t.string   :type, null: false
      t.string   :contributor, null: false
      t.decimal  :amount, precision: 25, scale: 2, null: false
      t.string   :interest_type, null: false
      t.decimal  :monthly_interest, precision: 10, scale: 2, null: false
      t.integer  :compound_times_annually, default: 0
      t.date     :maturity, null: false
      t.decimal  :interest_balance, precision: 25, scale: 2, null: false
      t.decimal  :amount_balance, precision: 25, scale: 2, default: 0, null: false
      t.decimal  :total_balance, precision: 25, scale: 2, default: 0, null: false
      t.string   :info, :limit => 200
      t.string   :status, null: false
      t.integer  :asset_id
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :loans, [:date_granted, :firm_id]
    add_index :loans, [:firm_id, :year]
    add_index :loans, [:firm_id, :type]
    add_index :loans, [:firm_id, :interest_type]

    create_table :deposits do |t|
      t.date     :date_granted, null: false
      t.integer  :year, null: false
      t.integer  :duration, null: false
      t.string   :holder, null: false
      t.decimal  :amount, precision: 25, scale: 2, null: false
      t.string   :interest_type, null: false
      t.decimal  :interest, precision: 10, scale: 2, null: false
      t.integer  :compound_times_annually, default: 0
      t.date     :maturity, null: false
      t.decimal  :interest_balance, precision: 25, scale: 2, null: false
      t.decimal  :amount_balance, precision: 25, scale: 2, default: 0, null: false
      t.decimal  :total_balance, precision: 25, scale: 2, default: 0, null: false
      t.string   :info, :limit => 200
      t.string   :status, null: false
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :deposits, [:date_granted, :firm_id]
    add_index :deposits, [:firm_id, :interest_type]
  end
end
