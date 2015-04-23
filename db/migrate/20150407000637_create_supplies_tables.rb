class CreateSuppliesTables < ActiveRecord::Migration
  def change
    create_table :expendables do |t|
	  t.string  :account_type, null: false
	  t.string  :item_name, null: false
	  t.decimal :unit, precision: 25, scale: 2, null: false
	  t.decimal :unit_expensed, precision: 25, scale: 2, null: false
	  t.string  :measurement
	  t.decimal :value, precision: 25, scale: 3, null: false
	  t.decimal :value_per_unit, precision: 25, scale: 3, null: false
	  t.decimal :value_expensed, precision: 25, scale: 3, null: false
	  t.boolean :perishable, default: false
	  t.date 	:expiration
	  t.boolean :perished, default: false
	  t.integer :spending_id, null: false
	  t.integer :firm_id, null: false
      t.timestamps null: false
    end
    add_index :expendables, [:firm_id, :spending_id]
    add_index :expendables, [:firm_id, :account_type]

    create_table :discards do |t|
      t.date :date_of_write_off, null: false
      t.integer :year, null: false
      t.decimal :quantity, precision: 25, scale: 2, default: 0, null: false
      t.boolean :earning, default: false
      t.decimal :cost_incurred, precision: 25, scale: 0
      t.decimal :item_value, precision: 25, scale: 0
      t.string	:info, limit: 200
      t.references :discardable, polymorphic: true
      t.references :firm, null: false      
      t.timestamps null: false
    end
    add_index :discards, :year
    add_index :discards, :firm_id
    add_index :discards, [:year, :firm_id]
    add_index :discards, [:firm_id, :discardable_type]      

  end      
end
