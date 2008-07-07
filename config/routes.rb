ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"
  
  #map.resources :users
  map.resources :users do |user|
    user.resources :orders, :name_prefix => "user_"
  end
  
  map.resource :session
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.welcome '', :controller => "categories"
  
  map.resources :categories do |category|
    category.resources :products, :name_prefix => "category_"
  end
  
  map.resources :products do |product|
    product.resources :batches, :name_prefix => "product_"
    product.resources :orders, :name_prefix => "product_", :member => {:created => :get, :destroyed => :get}
  end
  
  map.resources :batches do |batch|
    #batch.resources :orders, :name_prefix => "batch_", :member => {:created => :get, :destroyed => :get}
  end
  
  #map.resources :orders
  map.resources :orders do |order|
    order.resources :orders_from_batches, :name_prefix => "order_", :member => {:updated => :get}
  end
  
  map.resources :orders_from_batches
  
end
