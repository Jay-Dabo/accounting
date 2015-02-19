class CreateMerchandises < ActiveRecord::Migration
  def change
    create_table :merchandises do |t|
      t.date :date_added
      t.string :merch_name, default: "", null: false
      t.decimal :stock, precision: 15, scale: 2, default: 0, null: false
      t.string  :measurement
      t.decimal :price, precision: 15, scale: 2, default: 0, null: false
      t.references :firm
      t.timestamps null: false
    end
    add_index :merchandises, :merch_name
  end
end
