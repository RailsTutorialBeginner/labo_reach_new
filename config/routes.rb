Rails.application.routes.draw do

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/student_signup',  to: 'students#new'
  post '/student_signup', to: 'students#create'
  get '/student_login', to: 'student_sessions#new'
  post '/student_login', to: 'student_sessions#create'
  delete '/student_logout', to: 'student_sessions#destroy'
  resources :students
  resources :student_account_activations, only: [:edit]
end
