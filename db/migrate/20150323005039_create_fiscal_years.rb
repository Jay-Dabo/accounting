class CreateFiscalYears < ActiveRecord::Migration
  def change
    create_table :fiscal_years do |t|
      t.integer :current_year, null: false
      t.date	:beginning, null: false
      t.date	:ending, null: false
      t.integer :next_year, null: false
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :fiscal_years, :firm_id, unique: true
    add_index :fiscal_years, [:current_year, :firm_id], unique: true
    add_index :fiscal_years, [:next_year, :firm_id], unique: true
  end
end
