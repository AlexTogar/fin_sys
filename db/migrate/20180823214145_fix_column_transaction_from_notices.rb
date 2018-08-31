# frozen_string_literal: true

class FixColumnTransactionFromNotices < ActiveRecord::Migration[5.2]
  def change
    remove_column :notices, :transaction, :bigint
    add_column :notices, :tran, :bigint
  end
end
