class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.belongs_to  :plan, null: false
      t.belongs_to  :firm, null: false
      t.integer 		:status, null: false
      t.date 		    :start, null: false
      t.date 		    :end, null: false
      t.timestamps null: false
    end
    add_index :subscriptions, :firm_id
    add_index :subscriptions, :plan_id
    add_index :subscriptions, :status
    add_index :subscriptions, [:plan_id, :firm_id]

    create_table :plans do |t|
      t.string :name, null: false
      t.decimal :price, null: false
      t.integer :duration, null: false
      t.text :description
      t.timestamps null: false
	end

    create_table :payments do |t|
      t.string 		:payment_code, null: false
      t.integer 	:total_payment
      t.belongs_to  :subscription, null: false
      t.timestamps null: false
	end
	add_index :payments, [:subscription_id, :payment_code]
  add_index :payments, :payment_code
	add_index :payments, :subscription_id
  end
end
