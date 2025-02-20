Rails.application.routes.draw do
  get 'orders/new'
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/product_detail/:id", to: "products#show"
    get "/order-lookup", to: "orders#show_track"
    get "/order-track", to: "orders#find_order"
    resources :users do
      member do
        get :cart, to: "carts#show"
        patch :cart, to: "carts#update"
        delete :cart, to: "carts#destroy"
        patch :cart_checked, to: "carts#update_checked"
      end
    end
    resources :products
    resources :orders
  end
end
