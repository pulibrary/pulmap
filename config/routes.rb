# frozen_string_literal: true

Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  root to: 'catalog#index'
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
    concerns :range_searchable
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  get 'contact-us', to: 'feedback#new'
  post 'contact-us', to: 'feedback#create'

  mount Geoblacklight::Engine => 'geoblacklight'

  concern :gbl_exportable, Geoblacklight::Routes::Exportable.new
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :gbl_exportable
  end

  get '/catalog/:id/downloads' => 'catalog#downloads', as: 'downloads_solr_document'

  concern :gbl_wms, Geoblacklight::Routes::Wms.new
  namespace :wms do
    concerns :gbl_wms
  end

  concern :gbl_downloadable, Geoblacklight::Routes::Downloadable.new
  namespace :download do
    concerns :gbl_downloadable
  end

  resources :download, only: [:show]

  resources :suggest, only: :index, defaults: { format: 'json' }

  authenticate :user do
    match 'geoserver/restricted-figgy/*path' => 'geoserver#index', via: [:get]
    match 'geoserver/restricted-figgy-staging/*path' => 'geoserver#index', via: [:get]
  end
end
