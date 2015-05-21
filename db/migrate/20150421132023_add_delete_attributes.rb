class AddDeleteAttributes < ActiveRecord::Migration
  def change
  	add_column 	:assemblies, :deleted_at, :datetime, index: true
  	add_column 	:deposits, :deleted_at, :datetime, index: true
  	add_column 	:discards, :deleted_at, :datetime, index: true
  	add_column 	:funds, :deleted_at, :datetime, index: true
  	add_column 	:firms, :deleted_at, :datetime, index: true
  	add_column 	:other_revenues, :deleted_at, :datetime, index: true
  	add_column 	:loans, :deleted_at, :datetime, index: true
	  add_column 	:payable_payments, :deleted_at, :datetime, index: true
	  add_column 	:payments, :deleted_at, :datetime, index: true
  	add_column 	:processings, :deleted_at, :datetime, index: true
  	add_column 	:products, :deleted_at, :datetime, index: true
	  add_column 	:receivable_payments, :deleted_at, :datetime, index: true
  	add_column 	:revenues, :deleted_at, :datetime, index: true
  	add_column 	:spendings, :deleted_at, :datetime, index: true
  	add_column 	:works, :deleted_at, :datetime, index: true
  end
end
