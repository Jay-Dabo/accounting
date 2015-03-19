class CreateNestedResources < ActiveRecord::Migration
  def change
    create_table :merchandises do |t|
      t.string :merch_name, default: "", null: false
      t.decimal :quantity, precision: 25, scale: 2, null: false
      t.decimal :quantity_sold, precision: 25, scale: 2, null: false
      t.string  :measurement
      t.decimal :cost, precision: 25, scale: 2, null: false
      t.decimal :cost_per_unit, precision: 25, scale: 2, null: false
      t.decimal :cost_sold, precision: 25, scale: 2, null: false
      t.decimal :cost_remaining, precision: 25, scale: 2, null: false
      t.decimal :price, precision: 25, scale: 2, null: false
      t.string  :status, limit: 200
      t.integer :spending_id, null: false
      t.integer :firm_id, null: false
      t.timestamps null: false
    end
    add_index :merchandises, :merch_name
    add_index :merchandises, [:firm_id, :spending_id]

    create_table :assets do |t|
    t.string  :asset_type, null: false
    t.string  :asset_name, null: false
    t.decimal :unit, precision: 25, scale: 2, null: false
    t.decimal :unit_sold, precision: 25, scale: 2, null: false
    t.string  :measurement
    t.decimal :value, precision: 25, scale: 3, null: false
    t.decimal :value_per_unit, precision: 25, scale: 3, null: false
    t.decimal :useful_life
    t.decimal :depreciation_cost, precision: 25, scale: 3, default: 0, null: false
    t.decimal :accumulated_depreciation, precision: 25, scale: 3, default: 0, null: false
    t.string  :status, limit: 200
    t.integer :spending_id, null: false
    t.integer :firm_id, null: false
    t.timestamps null: false
    end
    add_index :assets, :asset_type
    add_index :assets, [:firm_id, :spending_id]

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
