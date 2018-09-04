class CreateDebts < ActiveRecord::Migration[5.2]
  def change
    create_table :debts do |t|
      t.boolean :you_debtor
      t.integer :sum, default: "0"
      t.string :debtor, default: "unspecified"
      t.boolean :local
      t.boolean :deleted, default: false
      t.timestamps
    end
  end
end
