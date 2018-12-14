require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest

  test "login" do #тест авторизации
    get "/users/sign_in"
    assert_response :success
    post "/users/sign_in",
         params: { user: { email: "test@mail.ru", password: "123123" } }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal request.original_url, base_new_transaction_url
  end

  test "registration" do #тест регистрации
    get '/users/sign_up'
    assert_response :success
    post "/users/sign_up",
         params: { user: { email: "miha1@mail.ru", password: "123123",  password_confirmation: "123123"} }
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal request.original_url, base_new_transaction_url
  end

  test "redirect_check" do #тест перенаправления на форму login при попытке доступа к странице
    get '/base/graph'
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_equal request.original_url, new_user_session_path
  end


end
