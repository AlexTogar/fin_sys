Rails.application.routes.draw do

  resources :transactions
  default_url_options :host => "localhost:3000"
  resources :reasons
  get 'base/graph'
  get 'base/main_tab'
  get 'base/join'
  get 'base/_navbar'
  get 'base/new_transaction'
  devise_for :users


  root to: "base#new_transaction"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
