Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'

      get '/merchants/most_items', to: 'merchants#most_items'

      get '/items/find_all', to: 'items#find_all'

      resources :merchants, only: [:index, :show]

      namespace :merchants do
        scope '/:id', :as => 'merchant' do
          resources :items, only: :index
        end
      end

      resources :items

      namespace :items do
        scope '/:id' do
          resource :merchant, only: :show
        end
      end

      namespace :revenue do
        resources :merchants, only: [:index, :show]
        resources :unshipped, only: [:index]
      end
    end
  end
end
