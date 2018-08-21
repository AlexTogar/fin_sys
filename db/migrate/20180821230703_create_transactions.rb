class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :sum
      t.text :description
      t.bigint :reason
      t.bigint :score
      t.bigint :user
      t.boolean :local
      t.integer :debt_sum
      t.string :debtor
      t.boolean :deleted

      t.timestamps
    end
  end
end
