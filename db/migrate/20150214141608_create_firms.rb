class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string     :name, null: false
      t.string     :type, null: false
      t.string     :industry, null: false
      t.string     :registration_code
      t.text       :description
      t.datetime   :last_active, null: false
      t.references :user, null: false
      t.timestamps null: false
    end
    add_index :firms, :user_id
    add_index :firms, :registration_code, unique: true
    add_index :firms, [:type, :user_id]
    add_index :firms, [:registration_code, :user_id]

    create_table :fiscal_years do |t|
      t.integer  :current_year, null: false
      t.date     :beginning, null: false
      t.date     :ending, null: false
      t.integer  :prev_year, null: false
      t.integer  :next_year, null: false
      t.string   :status, null: false
      t.references :firm, null: false
      t.timestamps null: false
    end
    add_index :fiscal_years, :firm_id, unique: true
    add_index :fiscal_years, [:current_year, :firm_id], unique: true
    add_index :fiscal_years, [:next_year, :firm_id], unique: true
  end
end
