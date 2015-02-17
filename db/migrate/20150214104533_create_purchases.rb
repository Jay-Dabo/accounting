class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.date    :date_of_purchase, null: false
      t.string  :type, null: false
      t.string  :item_name, null: false
      t.decimal :unit, precision: 15, scale: 3, null: false
      t.string  :measurement
      t.decimal :total_purchased, default: 0, null: false
      t.boolean :full_payment, default: false
      t.decimal :down_payment, :default => 0, precision: 15, scale: 2
      t.date    :maturity      
      t.string  :info, :limit => 200
      t.references :firm
      t.timestamps null: false
    end
    add_index :purchases, :date_of_purchase
    add_index :purchases, :firm_id
    add_index :purchases, [:date_of_purchase, :firm_id]
    add_index :purchases, [:type, :firm_id]
  end
end
