class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.date :date_of_income, null: false
      t.string  :type, null: false
      t.string :income_item, null: false
      t.decimal :unit, precision: 15, scale: 2, null: false
      t.string  :measurement
      t.decimal :total_earned, default: 0, null: false
      t.boolean :installment, default: false
      t.decimal :dp_received, :default => 0, precision: 15, scale: 2
      t.date 	:maturity
      t.string 	:info, :limit => 200
      t.references :firm
      t.timestamps null: false
    end
    add_index :incomes, :date_of_income
    add_index :incomes, :firm_id
    add_index :incomes, [:date_of_income, :firm_id]
    add_index :incomes, [:firm_id, :type]    
  end
end
