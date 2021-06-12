# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'admin/dashboard#index'
  patch '/invoice_items/:invoice_item_id/:status', to: 'invoice_items#update', as: 'invoice_item_patch'
  get '/items/:id', to: 'merchants/items#show'
  get '/invoices/:id', to: 'merchants/invoices#show'
  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :merchants, only: %i[index show edit update create]
    post '/merchants/:id/enabled', to: 'merchants#enabled'
    resources :invoices, only: %i[index show update]
  end

  namespace :merchants do
    get '/:id/dashboard', to: 'dashboard#index'

    get '/:id/items', to: 'items#index'
    get '/:id/items/:item_id', to: 'items#show'
    get '/:id/items/:item_id/edit', to: 'items#edit'
    patch '/:id/items/:item_id', to: 'items#update'
    post '/:id/items', to: 'items#create'

    get '/:id/invoices', to: 'invoices#index'
    get '/:id/invoices/:invoice_id', to: 'invoices#show', as: 'merch_invoice'
    patch '/:id/invoice_items/:invoice_item_id', to: 'invoices#show', as: 'patch_invoice_item'

    get '/:id/bulk_discounts/new', to: 'bulk_discounts#new', :as => 'new_discount'
    get '/:id/bulk_discounts', to: 'bulk_discounts#index', :as => 'bulk_discounts'
    get '/:id/bulk_discounts/:discount_id', to: 'bulk_discounts#show'
    post '/:id/bulk_discounts', to: 'bulk_discounts#create', :as => 'create_discount'
    delete '/:id/bulk_discounts/:discount_id', to: 'bulk_discounts#destroy', :as => 'delete_discount'
  end
end
