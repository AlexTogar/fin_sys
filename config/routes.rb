Rails.application.routes.draw do
  get 'base/graph'
  get 'base/main_tab'
  get 'base/join'
  devise_for :users


  root to: "base#graph"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
