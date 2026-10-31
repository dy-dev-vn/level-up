Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: %i[new create]

  resource :profile, only: %i[edit update]
  resources :evidence, only: %i[index new create] do
    resources :reviews, only: %i[create], controller: "evidence_reviews"
  end
  resources :reviewer_grants, only: %i[index create update]
  get "reviewer_workspace", to: "reviewer_workspace#index", as: :reviewer_workspace_index
  get "reviewer_workspace/evidence/:id", to: "reviewer_workspace#show", as: :reviewer_workspace

  root "dashboard#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
