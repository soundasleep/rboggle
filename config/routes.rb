Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root "welcome#index"

  resources :game, only: [ :show, :create ] do

  end

  get "/auth/google_login/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :logout

  get "sessions/new", :as => :login
end
