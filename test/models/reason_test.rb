# require_relative "../../app/models/reason.rb"
require 'test_helper'

class ReasonTest < ActiveSupport::TestCase
  #првоерка добавления. изменения и удаления причины
  test "add_reason" do
    test_user = User.find(email:"test@mail.ru")
    reason = "test_reason"
    sign = false
    often = 0
    local = false
    deleted = false
    reason_added = Reason.new(reason:reason, sign:sign, often:often, local:local, user: test_user.id,deleted: deleted).save

    #проверка добавления
    assert reason_added

    reason = Reason.find(user: test_user.id)

    #проверка совпадения полей
    assert_equal reason.reason, reason
    assert_equal reason.sign, sign
    assert_equal reason.often, often
    assert_equal reason.local, local
    assert_equal reason.deleted, deleted

    #проверка изменения данных
    assert reason.update(reason: "other_reason" )

    #првоерка удаления
    reason_id = reason.id
    reason_deleted = reason.delete
    assert_equal reason_id, reason_deleted.id

  end
end
