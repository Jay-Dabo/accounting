class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.date :date_of_sale, null: false
      t.string  :type, null: false
      t.string 	:item_name, null: false
      t.decimal :unit, precision: 15, scale: 3, null: false
      t.string  :measurement
      t.decimal :total_earned, default: 0, null: false
      t.boolean :full_payment, default: false
      t.decimal :down_payment, :default => 0, precision: 15, scale: 2
      t.date 	:maturity
      t.string 	:info, :limit => 200
      t.references :firm
      t.timestamps null: false
    end
    add_index :sales, :date_of_sale
    add_index :sales, :firm_id
    add_index :sales, [:date_of_sale, :firm_id]
    add_index :sales, [:firm_id, :type]    
  end
end
