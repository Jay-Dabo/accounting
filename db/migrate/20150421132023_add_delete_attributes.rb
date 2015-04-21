class AddDeleteAttributes < ActiveRecord::Migration
  def change
  	add_column 	:assemblies, :deleted, :boolean, default: false
  	add_column 	:deposits, :deleted, :boolean, default: false
  	add_column 	:discards, :deleted, :boolean, default: false
  	add_column 	:funds, :deleted, :boolean, default: false
  	add_column 	:firms, :deleted, :boolean, default: false  	
  	add_column 	:other_revenues, :deleted, :boolean, default: false
  	add_column 	:loans, :deleted, :boolean, default: false
	add_column 	:payable_payments, :deleted, :boolean, default: false
	add_column 	:payments, :deleted, :boolean, default: false
  	add_column 	:processings, :deleted, :boolean, default: false
  	add_column 	:products, :deleted, :boolean, default: false
	add_column 	:receivable_payments, :deleted, :boolean, default: false
  	add_column 	:revenues, :deleted, :boolean, default: false
  	add_column 	:spendings, :deleted, :boolean, default: false
  	add_column 	:works, :deleted, :boolean, default: false
  end
end
