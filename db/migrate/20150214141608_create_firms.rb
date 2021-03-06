class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string     :name, null: false
      t.string     :type, null: false
      t.string     :industry, null: false
      t.string     :registration_code
      t.boolean    :hardcore, default: false
      t.string     :starter_email
      t.string     :starter_phone
      t.datetime   :last_active, null: false
      t.timestamps null: false
    end
    add_index :firms, :registration_code, unique: true
    add_index :firms, :type
    add_index :firms, :industry
    add_index :firms, :hardcore

    create_table :memberships do |t|
      t.integer    :user_id, null: false
      t.integer    :firm_id, null: false
      t.string     :role
      t.string     :status
      t.timestamps null: false
    end
    add_index :memberships, [:user_id, :firm_id], unique: true
    add_index :memberships, [:user_id, :role]
    add_index :memberships, [:firm_id, :role]

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
    add_index :fiscal_years, [:prev_year, :firm_id], unique: true
    add_index :fiscal_years, [:current_year, :firm_id], unique: true
    add_index :fiscal_years, [:next_year, :firm_id], unique: true
  end
end
