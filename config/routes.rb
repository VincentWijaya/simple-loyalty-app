Rails.application.routes.draw do
  resources :orders

  get '/customers/:id', to: 'customers#show', as: 'customer'
  get '/customers/:id/order_history', to: 'customers#order_history', as: 'order_history'
end
