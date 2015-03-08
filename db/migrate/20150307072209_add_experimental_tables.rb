class AddExperimentalTables < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :type
      t.boolean :contra
      t.references :firm, index: true, null: false
      t.timestamps
    end
    add_index :accounts, [:name, :type]

    create_table :entries do |t|
      t.string :description
      t.integer :commercial_document_id
      t.string :commercial_document_type

      t.timestamps
    end
    add_index :entries, [:commercial_document_id, :commercial_document_type], :name => "index_entries_on_commercial_doc"

    create_table :amounts do |t|
      t.string :type
      t.references :account, null: false
      t.references :entry, null: false
      t.decimal :amount, :precision => 25, :scale => 10
    end 
    add_index :amounts, :type
    add_index :amounts, [:account_id, :entry_id]
    add_index :amounts, [:entry_id, :account_id]
  end
end
