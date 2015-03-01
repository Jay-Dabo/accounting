class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :expense_type, null: false
      t.string :expense_name, default: ""
      t.decimal :quantity, precision: 25, scale: 2, null: false
      t.string  :measurement
      t.decimal :cost, precision: 25, scale: 0, null: false
      t.integer :spending_id, null: false
      t.integer :firm_id, null: false      
      t.timestamps null: false
    end
    add_index :expenses, :expense_type
    add_index :expenses, [:firm_id, :spending_id]    
  end
end
