class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.date  	:date_of_booking, null: false
      t.integer	:year
      t.string	:input_to, null: false
      t.string	:message_text, null: false
      t.text    :contents, null: false
      t.string	:phone_number, null: false
      t.integer :sms_id, null: false
      t.integer	:user_id, null: false
      t.integer	:firm_id, null: false
      t.timestamps null: false
    end
    add_index 	:bookings, [:firm_id, :year]
    add_index 	:bookings, [:firm_id, :user_id]
    add_index   :bookings, [:id, :firm_id]
    add_index   :bookings, [:firm_id, :phone_number]
  end
end