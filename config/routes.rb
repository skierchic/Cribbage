Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#index'
  namespace :api do
    namespace :v1 do
      resources :games, only: [:create, :update, :index, :show] do
        resources :rounds, only: [:create]
      end
      resources :rounds, only: [:update, :show, :delete]
    end
  end
  get '*path', to: 'static_pages#index'
end
