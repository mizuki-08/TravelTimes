Rails.application.routes.draw do
devise_for :users, controllers: {   registrations: 'users/registrations',
                                    sessions: 'users/sessions' }
  
  resources :users, only: [:show] # ユーザーマイページへのルーティング
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  resources:travels
  root 'travels#index'

  # root "travels#index"

  get "/worldmap", to: "travels#worldmap"
  get "/news/:country", to: "news#index", as: "news"


  # Defines the root path route ("/")
  # root "posts#index"
end



