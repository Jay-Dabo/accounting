class CreateReceivablePayments < ActiveRecord::Migration
  def change
    create_table :receivable_payments do |t|
      t.date    :date_of_payment, null: false
      t.decimal :amount, precision: 25, scale: 2, null: false
      t.string  :info, :limit => 200
      t.integer :firm_id, null: false
      t.integer :spending_id, null: false
      t.timestamps null: false
    end
    add_index :receivable_payments, [:date_of_payment, :firm_id]
    add_index :receivable_payments, [:firm_id, :spending_id]    
  end
end
