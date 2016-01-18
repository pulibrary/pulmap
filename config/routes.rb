Rails.application.routes.draw do
  root to: "catalog#index"
  blacklight_for :catalog
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :suggest, only: :index, defaults: { format: 'json' }
end
