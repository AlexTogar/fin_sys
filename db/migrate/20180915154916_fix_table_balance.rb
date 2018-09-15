class FixTableBalance < ActiveRecord::Migration[5.2]
  def change
    drop_table :balance_chenges
  end
end
