Rails.application.routes.draw do

  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :flats
  resources :orders, only: [:show, :create] do
    resources :payments, only: :new
    member do
      post "/cancel" => "orders#cancel"
    end
  end

  post "flats/add_to_cart/:id", to: "flats#add_to_cart", as: "add_to_cart"
  delete "flats/remove_from_cart/:id", to: "flats#remove_from_cart", as: "remove_from_cart"

  mount StripeEvent::Engine, at: '/stripe-webhooks'
   default_url_options :host => "example.com"

   # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end

