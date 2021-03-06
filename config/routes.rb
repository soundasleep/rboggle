Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root "welcome#index"

  resources :game, only: [ :show, :create ] do
    post :ready
    post :not_ready

    resources :players, only: [ ] do
      post :kick      # TODO this would be a DELETE using REST
    end

    resources :board, only: [ :show ] do
      post :submit    # TODO this would be /guesses/create
    end
  end

  get "/auth/google_login/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", as: :logout

  get "sessions/new", as: :login
end
