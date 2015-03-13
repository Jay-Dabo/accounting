class CreateFundsAndLoans < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.date :date_granted, null: false
      t.string :type, null: false
      t.string :contributor, null: false
      t.decimal :amount, precision: 25, scale: 2, null: false
      t.decimal :ownership, precision: 5, scale: 2
      t.string :info, :limit => 200
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :funds, :date_granted
    add_index :funds, :firm_id
    add_index :funds, [:date_granted, :firm_id]
    add_index :funds, [:firm_id, :type]

    create_table :loans do |t|
      t.date :date_granted, null: false
      t.string :type, null: false
      t.string :contributor, null: false
      t.decimal :amount, precision: 25, scale: 2, null: false
      t.decimal :interest, precision: 10, scale: 2, null: false
      t.date :maturity, null: false
      t.decimal :amount_after_interest, precision: 25, scale: 2, null: false
      t.string :info, :limit => 200
      t.integer :asset_id
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :loans, :date_granted
    add_index :loans, :firm_id
    add_index :loans, [:date_granted, :firm_id]
    add_index :loans, [:firm_id, :type]
    add_index :loans, [:firm_id, :asset_id]
  end
end
