class CreateDiscards < ActiveRecord::Migration
  def change
    create_table :discards do |t|
      t.date :date_of_write_off, null: false
      t.integer :year, null: false
      t.decimal :quantity, precision: 25, scale: 2, default: 0, null: false
      t.boolean :earning, default: false
      t.decimal :total_earned, precision: 25, scale: 0
      t.decimal :down_payment, precision: 25, scale: 0
      t.decimal :discount, precision: 25, scale: 2
      t.date  	:maturity      
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
