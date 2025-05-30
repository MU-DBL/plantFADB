Rails.application.routes.draw do
  scope '/plantfadb' do
    resources :dbxrefs
    resources :fatty_acids
    resources :results do
      get 'plant_yield', on: :collection
    end
    resources :measures do
      get :autocomplete_measure_name, :on => :collection
    end
    resources :plants do
      get :autocomplete_plant_name, :on => :collection
    end
    resources :pubs do
      collection do
        post 'condense_doi'
        post 'condense_wos'
      end
    end
    resources :plants_pubs
    resources :drafts
    devise_for :users
    resources :users
    resources :pages
    resources :tree, only: :index do
      get 'data', on: :collection
    end
    resources :datasets
    resources :tree_nodes do
      get :manage, on: :collection
      collection do
        post :sort
      end
    end
    # The priority is based upon order of creation: first created -> highest priority.
    # See how all your routes lay out with "rake routes".

    # You can have the root of your site routed with "root"
    root 'home#index'
    # root to: proc { [200, {}, ['OK']] }
    get 'stats' => 'stats#index'
    get 'history' => 'history#index'
    get 'species' => 'species#index', as: 'species'
    get ':genus/:species' => 'species#show', as: 'species_page'
    
    get 'bulk_uploads' => 'bulk_uploads#index'
    post 'check_file' => 'bulk_uploads#check_file'
    post 'process_file' => 'bulk_uploads#process_file'
    
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
end
