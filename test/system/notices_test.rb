require "application_system_test_case"

class NoticesTest < ApplicationSystemTestCase
  setup do
    @notice = notices(:one)
  end

  test "visiting the index" do
    visit notices_url
    assert_selector "h1", text: "Notices"
  end

  test "creating a Notice" do
    visit notices_url
    click_on "New Notice"

    fill_in "Deleted", with: @notice.deleted
    fill_in "Destination", with: @notice.destination
    fill_in "Text", with: @notice.text
    fill_in "Transaction", with: @notice.transaction
    fill_in "User", with: @notice.user
    click_on "Create Notice"

    assert_text "Notice was successfully created"
    click_on "Back"
  end

  test "updating a Notice" do
    visit notices_url
    click_on "Edit", match: :first

    fill_in "Deleted", with: @notice.deleted
    fill_in "Destination", with: @notice.destination
    fill_in "Text", with: @notice.text
    fill_in "Transaction", with: @notice.transaction
    fill_in "User", with: @notice.user
    click_on "Update Notice"

    assert_text "Notice was successfully updated"
    click_on "Back"
  end

  test "destroying a Notice" do
    visit notices_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Notice was successfully destroyed"
  end
end
