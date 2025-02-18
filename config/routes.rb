Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/product_detail/:id", to: "products#show"
    resources :users do
      member do
        get :cart, to: "carts#show"
        patch :cart, to: "carts#update"
        delete :cart, to: "carts#destroy"
      end
    end
    resources :products
  end
end
