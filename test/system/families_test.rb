require "application_system_test_case"

class FamiliesTest < ApplicationSystemTestCase
  setup do
    @family = families(:one)
  end

  test "visiting the index" do
    visit families_url
    assert_selector "h1", text: "Families"
  end

  test "creating a Family" do
    visit families_url
    click_on "New Family"

    fill_in "Connect", with: @family.connect
    fill_in "Deleted", with: @family.deleted
    fill_in "Name", with: @family.name
    fill_in "User", with: @family.user
    click_on "Create Family"

    assert_text "Family was successfully created"
    click_on "Back"
  end

  test "updating a Family" do
    visit families_url
    click_on "Edit", match: :first

    fill_in "Connect", with: @family.connect
    fill_in "Deleted", with: @family.deleted
    fill_in "Name", with: @family.name
    fill_in "User", with: @family.user
    click_on "Update Family"

    assert_text "Family was successfully updated"
    click_on "Back"
  end

  test "destroying a Family" do
    visit families_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Family was successfully destroyed"
  end
end
