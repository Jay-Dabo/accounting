class CreateRevenueItems < ActiveRecord::Migration
  def change
    create_table :works do |t|
	    t.string :work_name, null: false
      t.integer :firm_id, null: false
      t.timestamps null: false
    end
    add_index :works, :firm_id

    create_table :products do |t|
  	  t.string 	 :product_name, null: false
      t.integer  :hour_needed, default: 0
	    t.decimal  :beginning_quantity, precision: 25, scale: 2, default: 0, null: false
      t.decimal  :ending_quantity, precision: 25, scale: 2, default: 0, null: false
	    t.string 	 :measurement
      t.decimal  :cost_production, precision: 25, scale: 2
      t.integer  :firm_id, null: false
      t.timestamps null: false
    end
    add_index :products, :firm_id    

    create_table :materials do |t|
	    t.string :material_name, null: false
      t.decimal :quantity, precision: 25, scale: 2, null: false
      t.decimal :quantity_used, precision: 25, scale: 2, default: 0, null: false
      t.string  :measurement
      t.decimal :cost, precision: 25, scale: 2, null: false
      t.decimal :cost_per_unit, precision: 25, scale: 2, null: false
      t.decimal :cost_used, precision: 25, scale: 2, default: 0, null: false
      t.decimal :cost_remaining, precision: 25, scale: 2, null: false
      t.string  :status, limit: 200
      t.integer :spending_id, null: false
      t.integer :firm_id, null: false
      t.timestamps null: false
    end
    add_index :materials, :firm_id
    add_index :materials, [:firm_id, :spending_id]

    create_table :assemblies do |t|
      t.date    :date_of_assembly, null: false
      t.decimal :produced, precision: 25, scale: 2, default: 0, null: false
      t.decimal :total_cost, precision: 25, scale: 2
	    t.integer :product_id, null: false
      t.integer :firm_id, null: false
      t.timestamps null: false
    end
    add_index :assemblies, [:firm_id, :product_id]

    create_table :processings do |t|
	    t.decimal  :quantity_used, precision: 25, scale: 2, default: 0, null: false
	    t.decimal  :cost_used, precision: 25, scale: 2, default: 0, null: false
	    t.integer :material_id, null: false
      t.integer :assembly_id, null: false
      t.timestamps null: false
    end
    add_index :processings, [:assembly_id, :material_id]
  end
end
