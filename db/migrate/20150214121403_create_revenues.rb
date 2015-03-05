class CreateRevenues < ActiveRecord::Migration
  def change
    create_table :revenues do |t|
      t.date :date_of_revenue, null: false
      t.string  :revenue_type, null: false
      t.string  :revenue_item, null: false
      t.decimal :quantity, precision: 25, scale: 2, default: 0, null: false
      t.decimal :total_earned, precision: 25, scale: 0, null: false
      t.boolean :installment, default: false
      t.decimal :dp_received, precision: 25, scale: 0
      t.decimal :interest, precision: 15, scale: 2
      t.date 	:maturity
      t.string 	:info, :limit => 100
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :revenues, :date_of_revenue
    add_index :revenues, :firm_id
    add_index :revenues, [:date_of_revenue, :firm_id]
    add_index :revenues, [:firm_id, :revenue_type]    
  end
end
