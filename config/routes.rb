Rails.application.routes.draw do
  get 'org/show'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'home#home'
  get 'category/:id', to: 'category#show', as: 'show_category'
  get 'location/:id', to: 'location#show', as: 'show_location'
end
