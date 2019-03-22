Rails.application.routes.draw do
  get 'binance/index', to: 'binance#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
