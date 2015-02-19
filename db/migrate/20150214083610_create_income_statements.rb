class CreateIncomeStatements < ActiveRecord::Migration
  def change
    create_table :income_statements do |t|
      t.integer :year, null: false
	  t.decimal :revenue, default: 0, precision: 15, scale: 2
	  t.decimal :cost_of_revenue, default: 0, precision: 15, scale: 2
	  t.decimal :operating_expense, default: 0, precision: 15, scale: 2
	  t.decimal :other_revenue, default: 0, precision: 15, scale: 2
	  t.decimal :other_expense, default: 0, precision: 15, scale: 2
	  t.decimal :interest_expense, default: 0, precision: 15, scale: 2
	  t.decimal :tax_expense, default: 0, precision: 15, scale: 2
	  t.decimal :net_income, default: 0, precision: 15, scale: 2
	  t.boolean :locked, default: false
	  t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :income_statements, :firm_id
    add_index :income_statements, :year
    add_index :income_statements, [:firm_id, :year], unique: true    
  end
end
