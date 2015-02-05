Rails.application.routes.draw do
  get 'download/hgl/:id' => 'download#hgl', as: :download_hgl
  get 'download/file/:id' => 'download#file', as: :download_file
  resources :download, only: [:show, :file]
  post "wms/handle"
  root :to => "catalog#index"
  blacklight_for :catalog
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
end
