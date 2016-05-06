Rails.application.routes.draw do
  root 'static_pages#home'
  resources :sessions, only: [:new, :create, :delete]
  get 'login' => 'sessions#new'
  delete 'logout' => 'sessions#destroy'

  resources :users
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
end
