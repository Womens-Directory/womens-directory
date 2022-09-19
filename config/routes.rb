lead_num = /\d+(-.+)?/

Rails.application.routes.draw do
  namespace :admin do
    get 'birdseye/categories'
    get 'birdseye/categories/:id', to: 'birdseye#category', as: 'birdseye_category'
    get 'changes', to: 'changes#changes', as: 'changes'
    get 'user_invites', to: 'user_invites#new'
    post 'user_invites', to: 'user_invites#create'
    get 'user_permissions', to: 'user_permissions#index'
    post 'user_permissions', to: 'user_permissions#update'
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  comfy_route_cms_admin path: '/cms'
  passwordless_for :users

  get ':cat_id/:id', to: 'location#show', as: 'show_category_location', constraints: { cat_id: lead_num, id: lead_num }
  get ':id', to: 'category#show', as: 'show_category', constraints: { id: lead_num }
  get 'loc/:id', to: 'location#show', as: 'show_location'
  get 'org/:id', to: 'org#show', as: 'show_org'

  get 'user_location/request', as: 'request_user_location'
  post 'user_location/save', as: 'set_user_location'
  post 'user_location/clear', as: 'clear_user_location'
  post 'sort/name', as: 'sort_by_name', to: 'user_location#sort_by_name'
  post 'sort/distance', as: 'sort_by_distance', to: 'user_location#sort_by_distance'

  get 'search', to: 'search#search'
  post 'feedback', to: 'feedback#save', as: 'save_feedback'

  get 'submission', to: 'user_submission#form', as: 'submission_form'
  post 'submission', to: 'user_submission#create', as: 'create_submission'

  comfy_route_cms path: '/'
end
