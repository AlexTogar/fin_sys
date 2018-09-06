# frozen_string_literal: true

Rails.application.routes.draw do
  resources :debts
  resources :families
  resources :reasons
  resources :destinations
  resources :capitals
  resources :notices
  resources :fast_transactions
  resources :plan_tables
  resources :transactions
  default_url_options host: 'localhost:3000'
  get 'base/test_action'
  get 'base/graph'
  get 'base/main_tab'
  get 'base/join'
  get 'base/_navbar'
  get 'base/new_transaction'
  get 'base/response_on_new_transaction'
  get 'base/new_family'
  get 'base/new_reason'
  get 'base/create_new_reason'
  get 'base/leave_the_group'
  get 'base/delete_transaction'
  get 'base/new_debt'
  get 'base/new_fast_transaction'
  get 'base/create_new_fast_transaction'
  get 'base/update_table'
  get 'base/set_aside'
  get 'base/create_deposit'
  devise_for :users

  root to: 'base#new_transaction'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
