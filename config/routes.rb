Rails.application.routes.draw do
  root to: 'home#home'
  get 'category/:id', to: 'category#show'
end
