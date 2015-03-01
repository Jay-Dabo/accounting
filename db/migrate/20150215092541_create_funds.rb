class CreateFunds < ActiveRecord::Migration
  def change
    create_table :funds do |t|
      t.date :date_granted, null: false
      t.string :type, null: false
      t.boolean :loan, null: false
      t.string :contributor, null: false
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.decimal :interest, precision: 10, scale: 2
      t.date :maturity
      t.decimal :ownership, precision: 5, scale: 2
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :funds, :date_granted
    add_index :funds, :firm_id
    add_index :funds, [:date_granted, :firm_id]
    add_index :funds, [:firm_id, :type]
  end
end
