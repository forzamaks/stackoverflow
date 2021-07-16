require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks',
  confirmations: 'confirmations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  concern :voteble do
    member do
      patch :vote_up
      patch :vote_down
      delete :unvote
    end
  end

  concern :commentable do
    member do
      post :comment
    end
  end

  resources :questions, concerns: [:voteble, :commentable] do
    resources :subscriptions, only: %i[create destroy], shallow: true
    resources :answers, concerns: [:voteble, :commentable], shallow: true, only: %i[new create destroy update] do
      post :mark_as_best, on: :member
      post :comment
    end
  end

  post 'search', action: :index, controller: 'search'
  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create destroy update] do
        resources :answers, shallow: true, only: %i[index show create destroy update]
      end
    end
  end

  root to: "questions#index"
  resources :links, only: :destroy
  resources :rewards, only: :index
  
  mount ActionCable.server => '/cable'
end
