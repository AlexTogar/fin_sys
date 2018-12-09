# frozen_string_literal: true
require_relative 'app/models/reason.rb'
require_relative 'app/models/transaction.rb'
require 'test_helper'

class BaseControllerTest < ActionDispatch::IntegrationTest
  test 'should get graph' do
    get base_graph_url
    assert_response :success
  end

  test 'should get main_tab' do
    get base_main_tab_url
    assert_response :success
  end

  test 'should get join' do
    get base_join_url
    assert_response :success
  end

  #проверка работы метода response_on_new_transaction контроллера
  test 'create_new_tran' do
    get '/base/response_on_new_transaction.json?sum=10&reason=55&user=8'
    response_sum = @response.sum
    response_reason = @response.reason
    response_user = "test@mail.ru"

    #проверка ответа
    assert_equal response_reason, Reason.find(55).reason
    assert_equal response_sum,10
    assert_equal response_user, "test@mail.ru"

    Transaction.last.delete

  end
end
