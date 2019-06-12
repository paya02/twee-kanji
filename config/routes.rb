Rails.application.routes.draw do
  devise_for :users
  #root 'application#hello'
  root 'homes#index'

  get 'homes/index'
end
