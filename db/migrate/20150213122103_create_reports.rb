class CreateReports < ActiveRecord::Migration
  def change
    create_table :balance_sheets do |t|
      t.date    :start_date
      t.date    :end_date
      t.integer :year, null: false
      t.decimal :cash, :default => 0, precision: 25, scale: 2
      t.decimal :inventories, :default => 0, precision: 25, scale: 2
      t.decimal :receivables, :default => 0, precision: 25, scale: 2
      t.decimal :other_current_assets, :default => 0, precision: 25, scale: 2
      t.decimal :fixed_assets, :default => 0, precision: 25, scale: 2
      t.decimal :other_fixed_assets, :default => 0, precision: 25, scale: 2 
      t.decimal :payables, :default => 0, precision: 25, scale: 2
      t.decimal :debts, :default => 0, precision: 25, scale: 2
      t.decimal :retained, :default => 0, precision: 25, scale: 2
      t.decimal :capital, :default => 0, precision: 25, scale: 2
      t.decimal :drawing, :default => 0, precision: 25, scale: 2
      t.boolean :closed, default: false
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :balance_sheets, :firm_id
    add_index :balance_sheets, :year
    add_index :balance_sheets, [:firm_id, :year], unique: true

    create_table :income_statements do |t|
      t.date    :start_date
      t.date    :end_date
      t.integer :year, null: false
      t.decimal :revenue, default: 0, precision: 25, scale: 2
      t.decimal :cost_of_revenue, default: 0, precision: 25, scale: 2
      t.decimal :operating_expense, default: 0, precision: 25, scale: 2
      t.decimal :other_revenue, default: 0, precision: 25, scale: 2
      t.decimal :other_expense, default: 0, precision: 25, scale: 2
      t.decimal :interest_expense, default: 0, precision: 25, scale: 2
      t.decimal :tax_expense, default: 0, precision: 25, scale: 2
      t.decimal :net_income, default: 0, precision: 25, scale: 2
      t.decimal :dividend, default: 0, precision: 25, scale: 2
      t.decimal :retained_earning, default: 0, precision: 25, scale: 2
      t.boolean :locked, default: false
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :income_statements, :firm_id
    add_index :income_statements, :year
    add_index :income_statements, [:firm_id, :year], unique: true
  end
end
