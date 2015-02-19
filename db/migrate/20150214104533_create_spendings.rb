class CreateSpendings < ActiveRecord::Migration
  def change
    create_table :spendings do |t|
      t.date    :date_of_spending, null: false
      t.string  :type, null: false
      t.string  :account_type
      t.integer  :spending_item
      t.decimal :unit, precision: 15, scale: 2, null: false
      t.string  :measurement
      t.decimal :total_spent, precision: 15, scale: 3, default: 0, null: false
      t.boolean :installment, default: false
      t.decimal :dp_paid, :default => 0, precision: 15, scale: 2
      t.date    :maturity      
      t.string  :info, :limit => 200
      t.references :firm
      t.timestamps null: false
    end
    add_index :spendings, :date_of_spending
    add_index :spendings, :firm_id
    add_index :spendings, [:date_of_spending, :firm_id]
    add_index :spendings, [:type, :firm_id]
  end
end
