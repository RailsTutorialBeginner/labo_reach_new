Rails.application.routes.draw do

  get 'admins/new'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/student_signup',  to: 'students#new'
  post '/student_signup', to: 'students#create'
  get '/student_login', to: 'student_sessions#new'
  post '/student_login', to: 'student_sessions#create'
  delete '/student_logout', to: 'student_sessions#destroy'
  get '/school_signup', to: 'schools#new'
  get '/school_login', to: 'school_sessions#new'
  post '/school_login', to: 'school_sessions#create'
  delete '/school_logout', to: 'school_sessions#destroy'
  resources :students
  resources :schools
  resources :student_account_activations, only: [:edit]
  resources :school_account_activations, only: [:edit]
  resources :student_password_resets, only: [:new, :create, :edit, :update]
  resources :school_password_resets, only: [:new, :create, :edit, :update]
  resources :rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
  resources :events, only: [:index, :show, :create, :destroy]
  resources :laboratories, only: [:index, :show, :create, :destroy]
end
