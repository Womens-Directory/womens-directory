lead_num = /\d+(-.+)?/

Rails.application.routes.draw do
  namespace :admin do
    get 'birdseye/categories'
    get 'birdseye/categories/:id', to: 'birdseye#category', as: 'birdseye_category'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  comfy_route_cms_admin path: '/cms'
  passwordless_for :users

  get 'loc/:id', to: 'location#show', as: 'show_location'

  get ':cat_id/:id', to: 'location#show', as: 'show_category_location', constraints: { cat_id: lead_num, id: lead_num }
  get ':id', to: 'category#show', as: 'show_category', constraints: { id: lead_num }

  get 'org/:id', to: 'org#show', as: 'show_org'
  post 'feedback', to: 'feedback#save', as: 'save_feedback'

  comfy_route_cms path: '/'
end
