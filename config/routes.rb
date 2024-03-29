Activid::Application.routes.draw do

  mount RailsAdmin::Engine => '/backoffice', as: 'rails_admin'
  comfy_route :cms_admin, :path => '/admin'

  resource :orders do
    collection do
      get :checkout
      get :success
      post :submit_payment
      post :attach_coupon
    end

    resources :order_files
  end

  #root 'high_voltage/pages#show', id: 'home'
  root 'pages#home'
  resource :pages
  get 'about' => 'pages#about'
  get 'faq' => 'pages#faq'
  get 'videography-tips' => 'pages#videography_tips'
  get 'how-it-works' => 'pages#how_it_works'
  get 'videos' => 'pages#videos'

  # Make sure this routeset is defined last
  comfy_route :cms, :path => '/', :sitemap => false
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
