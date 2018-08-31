# frozen_string_literal: true

require 'test_helper'

class FastTransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fast_transaction = fast_transactions(:one)
  end

  test 'should get index' do
    get fast_transactions_url
    assert_response :success
  end

  test 'should get new' do
    get new_fast_transaction_url
    assert_response :success
  end

  test 'should create fast_transaction' do
    assert_difference('FastTransaction.count') do
      post fast_transactions_url, params: { fast_transaction: { deleted: @fast_transaction.deleted, local: @fast_transaction.local, often: @fast_transaction.often, reason: @fast_transaction.reason, sum: @fast_transaction.sum, user: @fast_transaction.user } }
    end

    assert_redirected_to fast_transaction_url(FastTransaction.last)
  end

  test 'should show fast_transaction' do
    get fast_transaction_url(@fast_transaction)
    assert_response :success
  end

  test 'should get edit' do
    get edit_fast_transaction_url(@fast_transaction)
    assert_response :success
  end

  test 'should update fast_transaction' do
    patch fast_transaction_url(@fast_transaction), params: { fast_transaction: { deleted: @fast_transaction.deleted, local: @fast_transaction.local, often: @fast_transaction.often, reason: @fast_transaction.reason, sum: @fast_transaction.sum, user: @fast_transaction.user } }
    assert_redirected_to fast_transaction_url(@fast_transaction)
  end

  test 'should destroy fast_transaction' do
    assert_difference('FastTransaction.count', -1) do
      delete fast_transaction_url(@fast_transaction)
    end

    assert_redirected_to fast_transactions_url
  end
end
