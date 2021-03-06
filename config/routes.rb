Mds::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  put 'update_password' => "main#update_password", :as => :update_password
  resources :authors do
    get 'merge_form', :on => :member
    put 'merge', :on => :member
    get :autocomplete_author_name, :on => :collection
    get 'page/:page', :action => :index, :on => :collection
    resources :stories do
      get 'move_form', :on => :member
      put 'move', :on => :member
      get :autocomplete_tag_name, :on => :collection
      resources :playlists
    end
  end

  get 'tags' => 'tags#index', :as => :tags
  get 'tags/:name' => 'tags#show', :as => :tag

  get 'recent' => 'recent#index', :as => :recent
  get 'recent/identified' => 'recent#identified', :as => :recent_identified
  get 'recent/requests' => 'recent#requests', :as => :recent_requests
  get 'recent/(:page)' => 'recent#index', :as => :recent
  get 'recent/identified/(:page)' => 'recent#identified', :as => :recent_identified
  get 'recent/requests/(:page)' => 'recent#requests', :as => :recent_requests

  get 'unparsed' => 'main#unparsed', :as => :unparsed

  resources :artists do
    get 'page/:page', :action => :index, :on => :collection
    get 'search', :on => :collection
    get 'merge_form', :on => :member
    put 'merge', :on => :member
    get :autocomplete_artist_name, :on => :collection
    resources :tracks do
      get 'move_form', :on => :member
      put 'move', :on => :member
      get 'search', :on => :collection
    end
  end
  resources :users

  get 'my/identified' => 'playlists#index', :as => :my_identified
  get 'my/requests' => 'playlists#index', :as => :my_requests

  get 'login' => 'main#login'
  post 'search' => 'main#search'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'recent#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
