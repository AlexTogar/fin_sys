class CreateDebts < ActiveRecord::Migration[5.2]
  def change

    create_table :debts do |t|
      t.boolean :you_debtor
      t.bigint :user
      t.integer :sum, default: "0"
      t.boolean :sign, default: true
      t.string :debtor, default: "unspecified"
      t.string :description, default: ""
      t.boolean :local
      t.boolean :deleted, default: false
      t.timestamps


    end
  end
end
