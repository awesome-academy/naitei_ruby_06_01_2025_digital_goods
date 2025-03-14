require "sidekiq/web"
Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    devise_for :users, controllers: { 
      registrations: "users/registrations",
      sessions: "users/sessions",
    }, path: "", path_names: {
      sign_up: "signup",
      sign_in: "login",
      sign_out: "logout"
    }
    get "/product_detail/:id", to: "products#show"
    get "/order-lookup", to: "orders#show_track"
    get "/order-track", to: "orders#find_order"

    resources :users do
      member do
        get :cart, to: "carts#show"
        patch :cart, to: "carts#update"
        delete :cart, to: "carts#destroy"
        post :cart, to: "carts#create"
        patch :cart_checked, to: "carts#update_checked"
      end

      collection do
        get :orders, to: "orders#history_order"
      end
    end
    resources :products
    resources :orders

    namespace :admin do 
      resources :products
      resources :orders
      get :category, to: "products#select_category"
      post :category, to: "products#save_category_session"
    end

    namespace :api do
      namespace :v1 do
        resources :orders, only: [:new, :create, :update] do
          get :history_order, on: :collection
          get :find_order, on: :collection
        end
      end
    end

    mount Sidekiq::Web => "/sidekiq"
  end
end
