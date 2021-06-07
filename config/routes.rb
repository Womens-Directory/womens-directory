Rails.application.routes.draw do
  namespace :admin do
    get 'birdseye/categories'
    get 'birdseye/categories/:id', to: 'birdseye#category', as: 'birdseye_category'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  comfy_route_cms_admin path: '/cms'
  passwordless_for :users

  root to: 'home#home'
  get 'location/:id', to: 'location#show', as: 'show_location'

  get ':id', to: 'category#show', as: 'show_category'
  get ':cat_id/:id', to: 'location#show', as: 'show_category_location'

  get 'org/:id', to: 'org#show', as: 'show_org'
  post 'feedback', to: 'feedback#save', as: 'save_feedback'

  comfy_route_cms path: '/'
end
