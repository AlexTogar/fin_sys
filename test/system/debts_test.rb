require "application_system_test_case"

class DebtsTest < ApplicationSystemTestCase
  setup do
    @debt = debts(:one)
  end

  test "visiting the index" do
    visit debts_url
    assert_selector "h1", text: "Debts"
  end

  test "creating a Debt" do
    visit debts_url
    click_on "New Debt"

    fill_in "Debtor", with: @debt.debtor
    fill_in "Deleted", with: @debt.deleted
    fill_in "Local", with: @debt.local
    fill_in "Sum", with: @debt.sum
    fill_in "You Debtor", with: @debt.you_debtor
    click_on "Create Debt"

    assert_text "Debt was successfully created"
    click_on "Back"
  end

  test "updating a Debt" do
    visit debts_url
    click_on "Edit", match: :first

    fill_in "Debtor", with: @debt.debtor
    fill_in "Deleted", with: @debt.deleted
    fill_in "Local", with: @debt.local
    fill_in "Sum", with: @debt.sum
    fill_in "You Debtor", with: @debt.you_debtor
    click_on "Update Debt"

    assert_text "Debt was successfully updated"
    click_on "Back"
  end

  test "destroying a Debt" do
    visit debts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Debt was successfully destroyed"
  end
end
