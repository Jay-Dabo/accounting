class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
	  t.string  :asset_type, null: false
	  t.string  :asset_name, null: false
	  t.decimal :unit, precision: 15, scale: 2, null: false
	  t.string  :measurement
	  t.decimal :value, precision: 15, scale: 3, default: 0, null: false
	  t.decimal :useful_life
	  t.decimal :depreciation, precision: 15, scale: 3, default: 0, null: false
	  t.integer :spending_id, null: false
	  t.integer :firm_id, null: false
      t.timestamps null: false
    end
    add_index :assets, :asset_type
    add_index :assets, [:firm_id, :spending_id]
  end
end
