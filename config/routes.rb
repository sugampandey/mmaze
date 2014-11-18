Musiquemaze::Application.routes.draw do
  resources :posts, :only => [:index, :show]
  

  
  devise_for :users, 
    :path_names => { 
      :sign_in => 'login', 
      :sign_out => 'logout' 
    }, 
    :controllers => { 
      :omniauth_callbacks => "authentications", 
      :sessions => "sessions" 
    } do
      match '/auth/facebook/logout' => 'sessions#facebook_logout', :as => :facebook_logout 
      match 'logout' => 'sessions#destroy', :as => :purge_user_session
    end
    
  resources :contacts, :only => [:create]
  resources :quizzes, :only => [:show] do 
    get 'search', :on => :collection
  end
  
  namespace :admin do 
    resources :posts do
      put 'publish', :on => :member
      put 'unpublish', :on => :member 
    end
    resources :seeders, :except => [:new, :edit]
    resources :categories
    resources :testimonials
    resources :quizzes do
      resources :questions, :shallow => true do
        resources :answers
        resources :clues, :shallow => true
      end
    end
    root :to => "categories#index"
  end

  match 'faq' => 'main#faq', :as => :faq
  match 'copyright' => 'main#copyright', :as => :copyright
  match 'policy' => 'main#policy', :as => :policy
  match 'contactus' => 'main#contactus', :as => :contactus
  match 'about' => 'main#about', :as => :about
  match 'terms' => 'main#terms', :as => :terms
  match 'testimonial' => 'main#testimonial', :as => :testimonial

  root :to => "main#index"

  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#error_404'
  end

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
