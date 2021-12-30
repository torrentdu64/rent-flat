Rails.application.routes.draw do



  devise_for :users, controllers: { :registrations => 'registrations' ,omniauth_callbacks: "omniauth_callbacks" }
  resources :merchant_settings, except: [:show, :index, :new , :create, :update, :edit, :destroy  ] do
      collection do
        post "/connect" => "merchant_settings#connect", :as => :connect_stripe
      end
  end
  resources :users, only: [:show, :edit, :update]
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/dashboard" => "flats#dashboards", as: :dashboards
  resources :flats do
    resources :prices
    member do
      # get "/prices", to: "prices#new", :as => :pricing_new
      # post "/prices", to: "prices#create", :as => :pricing_create
      # get "/prices/:id/edit", to: "prices#edit", :as => :pricing_edit
      # patch "/prices/:id", to: "prices#update", :as => :pricing_update
      # delete "/prices/:id", to: "prices#destroy", :as => :pricing_destroy
      post "/rent" => "orders#rent", :as => :create_rent
      post "/plan" => "flats#create_plan", :as => :create_plan
    end
  end

  resources :stripe_accounts
  #get 'stripe_accounts/full', to: 'stripe_accounts#full'
  get 'terms', to: 'stripe_accounts#terms'

  resources :bank_accounts

  resources :stripe_documents do
    collection do
      get "/identity_upload"  => "stripe_documents#identity_document", :as => :upload_id
      get "/address_upload"  => "stripe_documents#address_document", :as => :upload_address
    end
  end


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

