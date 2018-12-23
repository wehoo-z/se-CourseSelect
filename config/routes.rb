Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'homes#index'

  get   'courses/list/:name'  => 'courses#list',:as => 'query'

  resources :courses do
    member do
      get :select
      post :select   #wsy
      get :quit
      get :open
      get :close
    end
    collection do
      get :list
    end
  end

  resources :grades, only: [:index, :update]
  resources :users
  resources :notices
  resources :opensystems

  get 'sessions/login' => 'sessions#new'
  post 'sessions/login' => 'sessions#create'
  delete 'sessions/logout' => 'sessions#destroy'

  get 'credit/courses' => 'courses#credit'
  # get 'search/courses' => 'courses#search'
  
  get 'scheduler/courses' => 'courses#scheduler'
 
  #成绩单的导入导出
  get 'grades/export' =>"grades#export"
  post 'grades/import' =>"grades#import"
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
