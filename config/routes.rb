Rails.application.routes.draw do
  # require 'sidekiq/web'
  # mount Sidekiq::Web => 'binance/index' 
  root 'binance#index'
  # get 'binance/index', to: 'binance#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
