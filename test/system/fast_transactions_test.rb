# frozen_string_literal: true

require 'application_system_test_case'

class FastTransactionsTest < ApplicationSystemTestCase
  setup do
    @fast_transaction = fast_transactions(:one)
  end

  test 'visiting the index' do
    visit fast_transactions_url
    assert_selector 'h1', text: 'Fast Transactions'
  end

  test 'creating a Fast transaction' do
    visit fast_transactions_url
    click_on 'New Fast Transaction'

    fill_in 'Deleted', with: @fast_transaction.deleted
    fill_in 'Local', with: @fast_transaction.local
    fill_in 'Often', with: @fast_transaction.often
    fill_in 'Reason', with: @fast_transaction.reason
    fill_in 'Sum', with: @fast_transaction.sum
    fill_in 'User', with: @fast_transaction.user
    click_on 'Create Fast transaction'

    assert_text 'Fast transaction was successfully created'
    click_on 'Back'
  end

  test 'updating a Fast transaction' do
    visit fast_transactions_url
    click_on 'Edit', match: :first

    fill_in 'Deleted', with: @fast_transaction.deleted
    fill_in 'Local', with: @fast_transaction.local
    fill_in 'Often', with: @fast_transaction.often
    fill_in 'Reason', with: @fast_transaction.reason
    fill_in 'Sum', with: @fast_transaction.sum
    fill_in 'User', with: @fast_transaction.user
    click_on 'Update Fast transaction'

    assert_text 'Fast transaction was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Fast transaction' do
    visit fast_transactions_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Fast transaction was successfully destroyed'
  end
end
