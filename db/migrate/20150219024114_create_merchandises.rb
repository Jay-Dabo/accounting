class CreateMerchandises < ActiveRecord::Migration
  def change
    create_table :merchandises do |t|
      t.string :merch_name, default: "", null: false
      t.decimal :quantity, precision: 25, scale: 2, null: false
      t.string  :measurement
      t.decimal :cost, precision: 25, scale: 0, null: false
      t.decimal :price, precision: 25, scale: 0, null: false
      t.integer :spending_id, null: false
      t.integer :firm_id, null: false
      t.timestamps null: false
    end
    add_index :merchandises, :merch_name
    add_index :merchandises, [:firm_id, :spending_id]
  end
end
