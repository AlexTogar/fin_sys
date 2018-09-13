class FixChangeBalanceTable < ActiveRecord::Migration[5.2]
  def change
    add_column :balance_chenges, :user, :bigint
  end
end
