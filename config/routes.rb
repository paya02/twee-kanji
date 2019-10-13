Rails.application.routes.draw do
  get 'events/', to: 'events#index'

  get 'events/add'  
  post 'events/add', to: 'events#create'

  get 'events/:id', to: 'events#show'
  post 'events/adjustment/:id', to: 'events#adjustment', as: 'event_adjustment'
  post 'events/member-delete/:id', to: 'events#member_delete', as: 'member_delete'
  delete 'events/:id', to: 'events#destroy'

  get 'events/edit/:id', to: 'events#edit'
  patch 'events/edit/:id', to: 'events#update'

  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks',
    sessions: 'users/sessions'
  }
  
  devise_scope :user do
    get 'login', to: 'users/sessions#new'
  end

  root to: 'homes#index'
  get 'homes/index'
  get 'homes/sample_login', to: 'homes#sample_login'
end
