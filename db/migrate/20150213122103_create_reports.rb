class CreateReports < ActiveRecord::Migration
  def change
    create_table :balance_sheets do |t|
      t.date    :start_date
      t.date    :end_date
      t.integer :year, null: false
      t.monetize :cash, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :inventories, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :receivables, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :other_current_assets, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :fixed_assets, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :accumulated_depr, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :other_fixed_assets, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :payables, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :debts, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :retained, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :capital, :default => 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :drawing, :default => 0, precision: 35, scale: 2, currency: { present: false }
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
      t.monetize :revenue, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :cost_of_revenue, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :operating_expense, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :other_revenue, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :other_expense, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :interest_expense, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :tax_expense, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :net_income, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :dividend, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.monetize :retained_earning, default: 0, precision: 35, scale: 2, currency: { present: false }
      t.boolean :locked, default: false
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :income_statements, :firm_id
    add_index :income_statements, :year
    add_index :income_statements, [:firm_id, :year], unique: true
  end
end
