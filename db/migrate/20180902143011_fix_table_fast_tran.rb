class FixTableFastTran < ActiveRecord::Migration[5.2]
  def change
    add_column :fast_transactions, :name, :string
  end
end
