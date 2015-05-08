class CreateNestedResources < ActiveRecord::Migration
  def change
    create_table :merchandises do |t|
      t.string   :item_name, default: "", null: false
      t.decimal  :quantity, precision: 25, scale: 2, null: false
      t.decimal  :quantity_used, precision: 25, scale: 2, null: false, default: 0
      t.string   :measurement
      t.decimal  :cost, precision: 25, scale: 2, null: false
      t.decimal  :cost_used, precision: 25, scale: 2, null: false, default: 0
      t.decimal  :price, precision: 25, scale: 2
      t.string   :status, limit: 200
      t.string   :item_details, limit: 200
      t.integer  :firm_id, null: false
      t.timestamps null: false
    end
    add_index :merchandises, [:firm_id, :item_name]
    add_index :merchandises, :firm_id

    create_table :assets do |t|
      t.date    :date_recorded, null: false
      t.integer :year, null: false
      t.string  :item_type, null: false
      t.string  :item_name, null: false
      t.decimal :quantity, precision: 25, scale: 2, null: false
      t.decimal :quantity_used, precision: 25, scale: 2, null: false, default: 0
      t.string  :measurement
      t.decimal :cost, precision: 25, scale: 3, null: false
      t.decimal :value_per_unit, precision: 25, scale: 3, null: false
      t.decimal :useful_life
      t.decimal :accumulated_depreciation, precision: 25, scale: 3, default: 0, null: false
      t.decimal :total_depreciation, precision: 25, scale: 3, default: 0, null: false
      t.decimal :depreciation_cost, precision: 25, scale: 3, default: 0, null: false
      t.string  :status, limit: 200
      t.string  :item_details, limit: 200
      t.integer :firm_id, null: false
      t.timestamps null: false
    end
    add_index :assets, :item_type
    add_index :assets, [:firm_id, :item_type]
    add_index :assets, [:firm_id, :item_name]
    add_index :assets, [:firm_id, :year]

    create_table :expenses do |t|
      t.date    :date_recorded, null: false
      t.integer :year, null: false
      t.string   :item_type, null: false
      t.string   :item_name, default: ""
      t.decimal  :quantity, precision: 25, scale: 2, null: false
      t.string   :measurement
      t.decimal  :cost, precision: 25, scale: 0, null: false
      t.string   :item_details, limit: 200
      t.integer  :firm_id, null: false
      t.timestamps null: false
    end
    add_index :expenses, :item_type
    add_index :expenses, [:firm_id, :item_name]
    add_index :expenses, [:firm_id, :year]
  end
end
