Rails.application.routes.draw do
  get 'reales/index', to: 'reales#index', as: "index"

  post 'reales/calculate', to: 'reales#calculate', as: 'calculate'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
