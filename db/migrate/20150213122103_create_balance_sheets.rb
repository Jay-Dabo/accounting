class CreateBalanceSheets < ActiveRecord::Migration
  def change
    create_table :balance_sheets do |t|
      t.integer :year, null: false
      t.decimal :cash, :default => 0, precision: 15, scale: 2
      t.decimal :temp_investments, :default => 0, precision: 15, scale: 2
      t.decimal :inventories, :default => 0, precision: 15, scale: 2
      t.decimal :receivables, :default => 0, precision: 15, scale: 2
      t.decimal :supplies, :default => 0, precision: 15, scale: 2
      t.decimal :prepaids, :default => 0, precision: 15, scale: 2
      t.decimal :fixed_assets, :default => 0, precision: 15, scale: 2
      t.decimal :investments, :default => 0, precision: 15, scale: 2
      t.decimal :intangibles, :default => 0, precision: 15, scale: 2
      t.decimal :payables, :default => 0, precision: 15, scale: 2
      t.decimal :debts, :default => 0, precision: 15, scale: 2
      t.decimal :retained, :default => 0, precision: 15, scale: 2
      t.decimal :capital, :default => 0, precision: 15, scale: 2
      t.decimal :drawing, :default => 0, precision: 15, scale: 2
      t.references :user, null: false
      t.timestamps null: false
    end
    add_index :balance_sheets, :user_id
    add_index :balance_sheets, :year
    add_index :balance_sheets, [:user_id, :year], unique: true
  end
end
