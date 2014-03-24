Amazon::Application.routes.draw do
  resources :coupons

  get "omniauth_callbacks/facebook"
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :customers, :controllers => {:omniauth_callbacks => "customers/omniauth_callbacks"}
  resources :books, only: [:index, :show] do
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
    resources :ratings, only: :create
  end
  
  resources :authors, only: [:index, :show]
  resources :addresses, except: [:new, :index, :destroy, :show]
  resources :categories, only: [:index, :show]
  resources :order_items, except: [:create, :new, :index, :show] 
  resources :bill_addresses, except: [:create, :new, :index, :show, :destroy] 
  resources :ship_addresses, except: [:create, :new, :index, :show, :destroy] 
  resources :customer_ship_addresses, except: :index
  resources :customer_bill_addresses, except: :index
  resources :credit_cards, except: [:new, :index, :destroy, :show]
  resources :orders, except: [:new, :destroy, :update, :edit]

  get 'clear_cart', to: 'order_items#clear_cart'
  post 'add_to_order/:book_id', to: 'order_items#create', as: 'order_item_create'
  get 'cart', to: 'order_items#index', as: 'order_items'
  post 'update_with_coupon', to: 'orders#update_with_coupon', as: 'update_with_coupon'
  post 'remove_coupon', to: 'orders#remove_coupon', as: 'remove_coupon'
  get 'addresses/new', to: 'addresses#new', as: 'new_address'
  get 'credit_cards/new', to: 'credit_cards#new', as: 'new_credit_card'
  get 'order/checkout', to: 'orders#checkout'
  get 'step/:step', to: 'orders#next_step', as: 'step'
  get 'order/delivery', to: 'orders#delivery'
  get 'order/edit_delivery', to: 'orders#edit_delivery'
  patch 'order/update_delivery', to: 'orders#update_delivery'
  post 'order/add_delivery', to: 'orders#add_delivery'
  get 'order/confirm', to: 'orders#confirm'
  get 'order/complete', to: 'orders#place'

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
