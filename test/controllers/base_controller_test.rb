
require 'test_helper'

class BaseControllerTest < ActionDispatch::IntegrationTest
  test 'should get graph' do
    get base_graph_url
    assert_response :success
    assert_equal @response.content_type, "text/html"
    assert_select "h3", "Graph builder"
  end

  test 'should get debts' do
    get 'base/debts'
    assert_response :success
    assert_equal @response.content_type, "text/html"
    assert_select "h3", "Debts table"
  end

  test 'should get main_tab' do
    get base_main_tab_url
    assert_response :success
    assert_equal @response.content_type, "text/html"
    assert_select "h3", "The transaction table"
  end

  test 'should get join' do
    get base_join_url
    assert_response :success
    assert_equal @response.content_type, "text/html"
    assert_select "h3", "Your group"
  end

  #проверка работы метода response_on_new_transaction контроллера
  test 'should get transactions in json' do

    #проверка получения ответа
    get '/base/response_on_new_transaction.json?sum=10&reason=55&user=8' #тестовая причина и пользователь
    assert_response :success
    response_type = @response.content_type
    response_sum = @response.sum
    response_reason = @response.reason
    response_user = "test@mail.ru"

    #проверка типа
    assert_equal response_type, "text/json"

    #проверка ответа
    assert_equal response_reason, Reason.find(55).reason
    assert_equal response_sum,10
    assert_equal response_user, "test@mail.ru"

    Transaction.last.delete
  end

  test "should get new transaction" do
    get 'base/new_transaction'
    assert_response :success
    assert_equal @response.content_type, "text/html"
    assert_select "h3", "New transaction"
  end

  test 'get transactions table' do
    #добавление транзакции
    get '/base/response_on_new_transaction.json?sum=10&reason=55&user=8' #тестовая причина и пользователь
    transaction = Transaction.last
    #получение json для заполнения таблицы
    get "base/table_update?user=8&date_begin=#{Date.today}&date_end=#{Date.today}&reason=all&sign=all"
    expected_json = {
        id:transaction.id,
        sum: transaction.sum,
        user: "test@mail.ru",
        sign: false,
        reason:"plus_test",
        description: "Empty",
        date: transaction.created_at}

    assert_equal expected_json, @response

  end



end
