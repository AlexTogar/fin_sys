# frozen_string_literal: true

Rails.application.routes.draw do
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
  devise_for :users

  root to: 'base#new_transaction'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
