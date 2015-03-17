class CreateCashFlows < ActiveRecord::Migration
  def change
    create_table :cash_flows do |t|
      t.date    :start_date
      t.date    :end_date
      t.integer :year, null: false
      t.decimal :beginning_cash, default: 0, precision: 25, scale: 2, null: false
      t.decimal :net_cash_operating, default: 0, precision: 25, scale: 2, null: false
      t.decimal :net_cash_investing, default: 0, precision: 25, scale: 2, null: false
      t.decimal :net_cash_financing, default: 0, precision: 25, scale: 2, null: false
      t.decimal :net_change, default: 0, precision: 25, scale: 2, null: false
      t.decimal :ending_cash, default: 0, precision: 25, scale: 2, null: false
      t.boolean :closed, default: false
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :cash_flows, :firm_id
    add_index :cash_flows, :year
    add_index :cash_flows, [:firm_id, :year], unique: true    
  end
end
