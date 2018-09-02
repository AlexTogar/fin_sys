class AddYouDebtorToTran < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :you_debtor, :boolean
  end
end
