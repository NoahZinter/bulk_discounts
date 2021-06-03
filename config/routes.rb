Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'merchant#index'
  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :merchants, only: [:index]
    resources :invoices, only: [:index, :show]
  end

  namespace :merchant do
    get '/:id/dashboard', to: 'dashboard#index'
    # get '/:id/items/:id', to: 'items#show'
    # get '/:id/items', to: 'items#index'
    get '/:id/invoices', to: 'invoices#index'
  end

  resources :merchant do
    resources :items, only: [:index, :show]
  end
end
