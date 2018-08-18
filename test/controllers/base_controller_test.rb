require 'test_helper'

class BaseControllerTest < ActionDispatch::IntegrationTest
  test "should get graph" do
    get base_graph_url
    assert_response :success
  end

  test "should get main_tab" do
    get base_main_tab_url
    assert_response :success
  end

  test "should get join" do
    get base_join_url
    assert_response :success
  end

end
