require 'test_helper'

class BalanceChengesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @balance_chenge = balance_chenges(:one)
  end

  test "should get index" do
    get balance_chenges_url
    assert_response :success
  end

  test "should get new" do
    get new_balance_chenge_url
    assert_response :success
  end

  test "should create balance_chenge" do
    assert_difference('BalanceChenge.count') do
      post balance_chenges_url, params: { balance_chenge: { sum: @balance_chenge.sum } }
    end

    assert_redirected_to balance_chenge_url(BalanceChenge.last)
  end

  test "should show balance_chenge" do
    get balance_chenge_url(@balance_chenge)
    assert_response :success
  end

  test "should get edit" do
    get edit_balance_chenge_url(@balance_chenge)
    assert_response :success
  end

  test "should update balance_chenge" do
    patch balance_chenge_url(@balance_chenge), params: { balance_chenge: { sum: @balance_chenge.sum } }
    assert_redirected_to balance_chenge_url(@balance_chenge)
  end

  test "should destroy balance_chenge" do
    assert_difference('BalanceChenge.count', -1) do
      delete balance_chenge_url(@balance_chenge)
    end

    assert_redirected_to balance_chenges_url
  end
end
