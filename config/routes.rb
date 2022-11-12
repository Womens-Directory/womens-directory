lead_num = /\d+(-.+)?/

Rails.application.routes.draw do
  namespace :admin do
    get 'birdseye/categories'
    get 'birdseye/categories/:id', to: 'birdseye#category', as: 'birdseye_category'
    get 'changes', to: 'changes#changes', as: 'changes'
    mount Flipper::UI.app(Flipper) => '/flipper', as: 'flipper', constraints: Features::AdminAuthorized
    get 'user_invites', to: 'user_invites#new'
    post 'user_invites', to: 'user_invites#create'
    get 'user_permissions', to: 'user_permissions#index'
    post 'user_permissions', to: 'user_permissions#update'
    get 'user_submissions', to: 'user_submissions#index'
    get 'user_submissions/reject/:id', to: 'user_submissions#reject_form', as: 'user_submissions_reject_form'
    post 'user_submissions/reject/:id', to: 'user_submissions#reject', as: 'user_submissions_reject'

    get 'fresh', to: 'fresh#index'
    namespace :fresh do
      get 'location', to: 'locations#new', as: 'new_location'
      post 'location', to: 'locations#create', as: 'create_location'
    end
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

  get 'submission', to: 'user_submissions#form', as: 'submission_form'
  post 'submission', to: 'user_submissions#create', as: 'create_submission', constraints: Features::FeatureAuthorizer.new(:user_submissions)
  get 'submission/confirm/:token', to: 'user_submissions#confirm', as: 'confirm_submission'

  comfy_route_cms path: '/'
end
