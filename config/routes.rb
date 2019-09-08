Rails.application.routes.draw do
  get 'events/add'  
  post 'events/add', to: 'events#create'

  get 'events/:id', to: 'events#show'
  post 'events/:id', to: 'events#adjustment'

  get 'events/edit/:id', to: 'events#edit'
  patch 'events/edit/:id', to: 'events#update'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
  end

  root to: 'homes#index'
  get 'homes/index'
end
