Rails.application.routes.draw do
  get 'events/:id', to: 'events#show'

  get 'events/add'  
  post 'events/add', to: 'events#create'

  get 'events/edit/:id', to: 'events#edit'
  patch 'events/edit/:id', to: 'events#update'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  
  devise_scope :user do
    root to: "devise/sessions#new"
    get 'login', to: 'devise/sessions#new'
  end

  get 'homes/index'
end
