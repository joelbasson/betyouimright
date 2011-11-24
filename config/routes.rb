Betyouimright::Application.routes.draw do
  break if ARGV.join.include? 'assets:precompile'
  
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :bonuses

  resources :notifications

  resources :bet_categories

  resources :authentications

  resources :categories
  resources :forums, :except => :index do
    resources :topics, :shallow => true, :except => :index do
      resources :posts, :shallow => true, :except => [:index, :show]
    end
    root :to => 'categories#index', :via => :get
  end

  match '/bets/feed', :controller => 'bets', :action => 'feed', :format => 'atom'
  match '/users/:user_id/publicprofile' => 'users#publicprofile', :as => :publicprofile
  match '/users/index' => 'users#index', :as => "users"
  match '/users/friends' => 'users#friends', :as => "userfriends"
  match '/users/:id/toggleadmin' => 'users#toggleadmin', :as => :toggleadmin
  match '/wagers/my_wagers' => 'wagers#my_wagers', :as => :my_wagers
  match '/bets/my_bets' => 'bets#my_bets', :as => :my_bets
  
  resources :comments do
    resources :comments
    get 'cancel'
    get 'cancel_new'
  end
  
  resources :cashouts, :except => [:show, :edit] 

  resources :purchases, :except => [:edit] do
    get 'payment_info'
  end  

  resources :payment_notifications
  
  resources :wallets, :only => [:show] do
    get 'editname'
    get 'updatename'
    get 'cancelname'
  end  

  resources :bets do
    collection do
        get 'search'
        get 'public'
        get 'private'
    end
    member do
        get 'won', :as => "won"
        get 'lost', :as => "lost"
    end
    resources :wagers, :except => [:index, :show, :create, :new, :destroy]
    resources :comments
  end  

  resources :transactions, :only => [:index]
  resources :bragging, :only => [:index]
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    get '/users/sign_out' => 'users#destroy'
  end
    
  match '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  match '/users/logout' => 'users#logout', :as => "logout"
  # match '/auth/:provider/callback' => 'authentications#create'  
  # match '/auth/failure', :to => 'authentications#failure'
  match '/transactions/my_transactions' => 'transactions#my_transactions', :as => :my_transactions
  match '/bets/:bet_id/comments/cancel' => 'comments#cancel', :as => :cancel_bet_comment
  match '/bets/:bet_id/wagers/:against' => 'wagers#bet_now', :as => :bet_now
  match '/sitemap', :controller => 'sitemaps', :action => 'index', :format => 'xml'
  match '/:action' => 'static#:action'
  # match '/auth/facebook/setup', :to => 'authentications#setup'
  match '/javascripts/:action.:format', :controller => 'javascripts'
  match '/bets/:id' => 'bets#show', :via => [:get, :post]
  constraints(Subdomain) do  
      match '/' => 'forums#show', :via => :get  
    end
  root :to => "bets#index"
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
