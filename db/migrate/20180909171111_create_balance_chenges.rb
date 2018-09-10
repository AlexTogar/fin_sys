class CreateBalanceChenges < ActiveRecord::Migration[5.2]
  def change
    create_table :balance_chenges do |t|
      t.integer :sum

      t.timestamps
    end
  end
end
