class FixTableTransactionsDeb < ActiveRecord::Migration[5.2]
  def change
    remove_column(:transactions, :debt_sum)
    remove_column(:transactions, :debtor)
    remove_column(:transactions, :you_debtor)
  end
end
