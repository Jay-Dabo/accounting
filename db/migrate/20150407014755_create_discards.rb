class CreateDiscards < ActiveRecord::Migration
  def change
    create_table :discards do |t|

      t.timestamps null: false
    end
  end
end
