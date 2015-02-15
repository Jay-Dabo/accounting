class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string :name, null: false
      t.string :business_type, null: false
      t.string :industry, null: false
      t.references :user, null: false
      t.timestamps null: false
    end
    add_index :firms, :user_id
    add_index :firms, :business_type
  end
end
