class CreateIncomeStatements < ActiveRecord::Migration
  def change
    create_table :income_statements do |t|
      t.integer :year, null: false
	  t.decimal :sales, :default => 0, precision: 15, scale: 2
	  t.decimal :cogs, :default => 0, precision: 15, scale: 2
	  t.decimal :operating_expenses, :default => 0, precision: 15, scale: 2
	  t.decimal :interest_expenses, :default => 0, precision: 15, scale: 2
	  t.decimal :tax_expenses, :default => 0, precision: 15, scale: 2
	  t.decimal :net_income, :default => 0, precision: 15, scale: 2
	  t.decimal :dividends, :default => 0, precision: 15, scale: 2
	  t.decimal :retained_earnings, :default => 0, precision: 15, scale: 2
	  t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :income_statements, :firm_id
    add_index :income_statements, :year
    add_index :income_statements, [:firm_id, :year], unique: true    
  end
end
