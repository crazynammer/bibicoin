Rails.application.routes.draw do
  
  resources :transactions

  post 'transactions/confirm'
  get 'static_pages/how', :as => :how
  get 'static_pages/bitcoins', :as => :bitcoins
  get 'static_pages/terms', :as => :terms
  #Need to get the variable :locale to generate uri 'transactions/new?locale=zh&ttype=0'
  get 'static_pages/howtobuy', :as => :howtobuy
  get 'static_pages/howtosell', :as => :howtosell
  get 'static_pages/jobs', :as => :jobs
  get 'static_pages/faq', :as => :faq
  get 'static_pages/privacy', :as => :privacy
  get 'static_pages/legal', :as => :legal
  get 'static_pages/why', :as => :why
  get 'static_pages/wallets', :as => :wallets
  get 'static_pages/news', :as => :news
  get 'static_pages/reviews', :as => :reviews
  get 'static_pages/about', :as => :about
  get 'static_pages/contact', :as => :contact
  get 'static_pages/home', :as => :home
  get 'static_pages/traditional', :as => :traditional
    
  # Bibicoin Root Route
  root 'static_pages#home' 
  
  #TODO: Need to add this for production https://github.com/iain/http_accept_language/tree/master
  
  # Locale settings
  scope "(:locale)", locale: /en|zh/ do
    resources :static_pages, :transactions, :layouts
  end  

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
