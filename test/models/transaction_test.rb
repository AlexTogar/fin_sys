# require_relative "../../app/models/transaction.rb"
require 'test_helper'

class TransactionTest < ActiveSupport::TestCase

   test "create delete update transaction" do
      data = {
          sum: 100,
          description: "products",
          reason: 1,
          user: 8, #test user
          local: false,
          deleted: false
      }

      #проверка добавления
      assert new_tran = Transaction.new(
                    sum: data[:sum],
                    description: data[:description],
                    reason: data[:reason],
                    user: data[:user],
                    local: data[:local],
                    deleted: data[:deleted]
         )
      #проверка обновления
      assert new_tran.update(sum: 200)

      #проверка удаления
      deleted_tran = new_tran.delete
      assert_equal deleted_tran.id , new_tran.id
   end

end
