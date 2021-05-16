Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  passwordless_for :users

  root to: 'home#home'
  get 'category/:id', to: 'category#show', as: 'show_category'
  get 'location/:id', to: 'location#show', as: 'show_location'
  get 'org/:id', to: 'org#show', as: 'show_org'
  post 'feedback', to: 'feedback#save', as: 'save_feedback'
end
