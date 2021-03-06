Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #
  root "home#index"

  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :tutor_schedules
  resources :tutors

  get "/home" => "home#index", as: "home"
  get "/student/lessons/schedule-enter" => "schedules#index"
  post "/student/lessons/schedule-enter" => "schedules#create"

  get "/student/lessons/reservation" => "schedules#reservation"
  delete "/student/lessons/reservation" => "schedules#destroy_reservation"

end