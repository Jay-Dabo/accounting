class CreateBalanceSheets < ActiveRecord::Migration
  def change
    create_table :balance_sheets do |t|
      t.integer :year, null: false
      t.decimal :cash, :default => 0, precision: 15, scale: 2
      t.decimal :inventories, :default => 0, precision: 15, scale: 2
      t.decimal :receivables, :default => 0, precision: 15, scale: 2
      t.decimal :other_current_assets, :default => 0, precision: 15, scale: 2
      t.decimal :fixed_assets, :default => 0, precision: 15, scale: 2
      t.decimal :other_fixed_assets, :default => 0, precision: 15, scale: 2 
      t.decimal :payables, :default => 0, precision: 15, scale: 2
      t.decimal :debts, :default => 0, precision: 15, scale: 2
      t.decimal :retained, :default => 0, precision: 15, scale: 2
      t.decimal :capital, :default => 0, precision: 15, scale: 2
      t.decimal :drawing, :default => 0, precision: 15, scale: 2
      t.boolean :closed, default: false
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :balance_sheets, :firm_id
    add_index :balance_sheets, :year
    add_index :balance_sheets, [:firm_id, :year], unique: true
  end
end
