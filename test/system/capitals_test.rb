require "application_system_test_case"

class CapitalsTest < ApplicationSystemTestCase
  setup do
    @capital = capitals(:one)
  end

  test "visiting the index" do
    visit capitals_url
    assert_selector "h1", text: "Capitals"
  end

  test "creating a Capital" do
    visit capitals_url
    click_on "New Capital"

    fill_in "Deleted", with: @capital.deleted
    fill_in "Local", with: @capital.local
    fill_in "Sum", with: @capital.sum
    fill_in "User", with: @capital.user
    click_on "Create Capital"

    assert_text "Capital was successfully created"
    click_on "Back"
  end

  test "updating a Capital" do
    visit capitals_url
    click_on "Edit", match: :first

    fill_in "Deleted", with: @capital.deleted
    fill_in "Local", with: @capital.local
    fill_in "Sum", with: @capital.sum
    fill_in "User", with: @capital.user
    click_on "Update Capital"

    assert_text "Capital was successfully updated"
    click_on "Back"
  end

  test "destroying a Capital" do
    visit capitals_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Capital was successfully destroyed"
  end
end
