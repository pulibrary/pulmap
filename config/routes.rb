# frozen_string_literal: true

Rails.application.routes.draw do
  mount HealthMonitor::Engine, at: "/"
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => "/"

  root to: "catalog#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: "catalog", path: "/catalog", controller: "catalog" do
    concerns :searchable
    concerns :range_searchable
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: "/catalog", controller: "catalog" do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete "clear"
    end
  end

  get "contact-us", to: "feedback#new"
  post "contact-us", to: "feedback#create"

  mount Geoblacklight::Engine => "geoblacklight"

  concern :gbl_exportable, Geoblacklight::Routes::Exportable.new
  resources :solr_documents, only: [:show], path: "/catalog", controller: "catalog" do
    concerns :gbl_exportable
  end

  concern :gbl_wms, Geoblacklight::Routes::Wms.new
  namespace :wms do
    concerns :gbl_wms
  end

  concern :gbl_downloadable, Geoblacklight::Routes::Downloadable.new
  namespace :download do
    concerns :gbl_downloadable
  end

  resources :download, only: [:show]

  resources :suggest, only: :index, defaults: { format: "json" }

  authenticate :user do
    get "geoserver/restricted-figgy/*path" => "geoserver#index"
    get "geoserver/restricted-figgy-staging/*path" => "geoserver#index"
  end

  require "sidekiq/web"
  authenticate :user,  ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
