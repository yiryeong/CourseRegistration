Rails.application.routes.draw do
  resources :tutor_schedules
  resources :tutors
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/home" => "home#index"
  get "/student/lessons/schedule-enter" => "schedule#index"

  root "home#index"
end
