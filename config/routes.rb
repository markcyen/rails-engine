Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
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
      end
    end
  end
end
