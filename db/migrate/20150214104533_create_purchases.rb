class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :date, null: false
      t.string :source, :limit => 200
      t.string :item, null: false
      t.integer :unit, default: 1, null: false
      t.decimal :total_purchased, default: 0, null: false
      t.boolean :full_payment, default: true
      t.decimal :down_payment
      t.date  :maturity      
      t.string :info, :limit => 200
      t.references :firm
      t.timestamps null: false
    end
    add_index :purchases, :date
    add_index :purchases, :firm_id
    add_index :purchases, [:date, :firm_id]
  end
end
