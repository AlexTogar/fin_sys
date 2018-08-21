require "application_system_test_case"

class TransactionsTest < ApplicationSystemTestCase
  setup do
    @transaction = transactions(:one)
  end

  test "visiting the index" do
    visit transactions_url
    assert_selector "h1", text: "Transactions"
  end

  test "creating a Transaction" do
    visit transactions_url
    click_on "New Transaction"

    fill_in "Debt Sum", with: @transaction.debt_sum
    fill_in "Debtor", with: @transaction.debtor
    fill_in "Deleted", with: @transaction.deleted
    fill_in "Description", with: @transaction.description
    fill_in "Local", with: @transaction.local
    fill_in "Reason", with: @transaction.reason
    fill_in "Score", with: @transaction.score
    fill_in "Sum", with: @transaction.sum
    fill_in "User", with: @transaction.user
    click_on "Create Transaction"

    assert_text "Transaction was successfully created"
    click_on "Back"
  end

  test "updating a Transaction" do
    visit transactions_url
    click_on "Edit", match: :first

    fill_in "Debt Sum", with: @transaction.debt_sum
    fill_in "Debtor", with: @transaction.debtor
    fill_in "Deleted", with: @transaction.deleted
    fill_in "Description", with: @transaction.description
    fill_in "Local", with: @transaction.local
    fill_in "Reason", with: @transaction.reason
    fill_in "Score", with: @transaction.score
    fill_in "Sum", with: @transaction.sum
    fill_in "User", with: @transaction.user
    click_on "Update Transaction"

    assert_text "Transaction was successfully updated"
    click_on "Back"
  end

  test "destroying a Transaction" do
    visit transactions_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Transaction was successfully destroyed"
  end
end
