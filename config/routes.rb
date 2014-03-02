Amazon::Application.routes.draw do
  get "omniauth_callbacks/facebook"
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :customers, :controllers => {:sessions => "sessions", :omniauth_callbacks => "customers/omniauth_callbacks"}
  resources :books do
    member do
      post 'add_wish'
      post 'remove_wish'
      get 'wishers'
    end
    collection do
      get 'author_filter/:author_id', to: 'books#author_filter', as: 'author_filter'
      get 'category_filter/:category_id', to: 'books#category_filter', as: 'category_filter'
      get 'top_rated', to: 'books#top_rated', as: 'top_rated'
    end
    resources :ratings
  end
  
  resources :authors 
  resources :categories 
  resources :order_items 
  resources :bill_addresses 
  resources :ship_addresses 
  resources :credit_cards 
  resources :orders 

  get 'clear_cart', to: 'order_items#clear_cart'
  post 'add_to_order/:book_id', to: 'order_items#add_to_order', as: 'add_to_order'

  root :to => "books#index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
