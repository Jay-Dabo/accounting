class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :date, null: false
      t.string 	:item, null: false
      t.integer :unit, null: false
      t.decimal :total_earned, default: 0, null: false
      t.boolean :full_payment, default: true
      t.decimal :down_payment
      t.date 	:maturity
      t.string 	:info, :limit => 200
      t.references :firm
      t.timestamps null: false
    end
    add_index :sales, :date
    add_index :sales, :firm_id
    add_index :sales, [:date, :firm_id]    
  end
end
