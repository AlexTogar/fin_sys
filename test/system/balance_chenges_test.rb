require "application_system_test_case"

class BalanceChengesTest < ApplicationSystemTestCase
  setup do
    @balance_chenge = balance_chenges(:one)
  end

  test "visiting the index" do
    visit balance_chenges_url
    assert_selector "h1", text: "Balance Chenges"
  end

  test "creating a Balance chenge" do
    visit balance_chenges_url
    click_on "New Balance Chenge"

    fill_in "Sum", with: @balance_chenge.sum
    click_on "Create Balance chenge"

    assert_text "Balance chenge was successfully created"
    click_on "Back"
  end

  test "updating a Balance chenge" do
    visit balance_chenges_url
    click_on "Edit", match: :first

    fill_in "Sum", with: @balance_chenge.sum
    click_on "Update Balance chenge"

    assert_text "Balance chenge was successfully updated"
    click_on "Back"
  end

  test "destroying a Balance chenge" do
    visit balance_chenges_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Balance chenge was successfully destroyed"
  end
end
