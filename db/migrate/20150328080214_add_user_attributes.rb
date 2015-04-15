class AddUserAttributes < ActiveRecord::Migration
  def change
	add_column :users, :username, :string, null: false
  	add_column :users, :full_name, :string, null: false
  	add_column :users, :phone_number, :string, null: false
  	add_index  :users, [:full_name, :phone_number]
  end
end
