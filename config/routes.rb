Rails.application.routes.draw do
  get 'events/show'
  get 'events/add'
  get 'events/edit'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  
  devise_scope :user do
    root to: "devise/sessions#new"
    get 'login', to: 'devise/sessions#new'
  end

  get 'homes/index'
end
