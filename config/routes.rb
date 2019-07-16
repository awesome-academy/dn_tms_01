Rails.application.routes.draw do
  root "sessions#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/home", to: "homes#index"

  scope :user do
    resources :course_users, only: :show
  end
  resources :courses, only: [:index, :show]
  namespace :supervisors do
    resources :users
    resources :courses, except: :show
  end
end
