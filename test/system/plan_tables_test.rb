require "application_system_test_case"

class PlanTablesTest < ApplicationSystemTestCase
  setup do
    @plan_table = plan_tables(:one)
  end

  test "visiting the index" do
    visit plan_tables_url
    assert_selector "h1", text: "Plan Tables"
  end

  test "creating a Plan table" do
    visit plan_tables_url
    click_on "New Plan Table"

    fill_in "Data", with: @plan_table.data
    fill_in "Date Begin", with: @plan_table.date_begin
    fill_in "Date End", with: @plan_table.date_end
    fill_in "Deleted", with: @plan_table.deleted
    fill_in "Local", with: @plan_table.local
    click_on "Create Plan table"

    assert_text "Plan table was successfully created"
    click_on "Back"
  end

  test "updating a Plan table" do
    visit plan_tables_url
    click_on "Edit", match: :first

    fill_in "Data", with: @plan_table.data
    fill_in "Date Begin", with: @plan_table.date_begin
    fill_in "Date End", with: @plan_table.date_end
    fill_in "Deleted", with: @plan_table.deleted
    fill_in "Local", with: @plan_table.local
    click_on "Update Plan table"

    assert_text "Plan table was successfully updated"
    click_on "Back"
  end

  test "destroying a Plan table" do
    visit plan_tables_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Plan table was successfully destroyed"
  end
end
