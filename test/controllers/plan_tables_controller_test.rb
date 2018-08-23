require 'test_helper'

class PlanTablesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plan_table = plan_tables(:one)
  end

  test "should get index" do
    get plan_tables_url
    assert_response :success
  end

  test "should get new" do
    get new_plan_table_url
    assert_response :success
  end

  test "should create plan_table" do
    assert_difference('PlanTable.count') do
      post plan_tables_url, params: { plan_table: { data: @plan_table.data, date_begin: @plan_table.date_begin, date_end: @plan_table.date_end, deleted: @plan_table.deleted, local: @plan_table.local } }
    end

    assert_redirected_to plan_table_url(PlanTable.last)
  end

  test "should show plan_table" do
    get plan_table_url(@plan_table)
    assert_response :success
  end

  test "should get edit" do
    get edit_plan_table_url(@plan_table)
    assert_response :success
  end

  test "should update plan_table" do
    patch plan_table_url(@plan_table), params: { plan_table: { data: @plan_table.data, date_begin: @plan_table.date_begin, date_end: @plan_table.date_end, deleted: @plan_table.deleted, local: @plan_table.local } }
    assert_redirected_to plan_table_url(@plan_table)
  end

  test "should destroy plan_table" do
    assert_difference('PlanTable.count', -1) do
      delete plan_table_url(@plan_table)
    end

    assert_redirected_to plan_tables_url
  end
end
