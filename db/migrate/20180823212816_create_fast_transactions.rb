class CreateFastTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :fast_transactions do |t|
      t.integer :sum
      t.bigint :reason
      t.integer :often
      t.bigint :user
      t.boolean :local
      t.boolean :deleted

      t.timestamps
    end
  end
end
