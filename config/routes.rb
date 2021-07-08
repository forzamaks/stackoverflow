Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :questions do
    resources :answers, shallow: true, only: %i[new create destroy update] do
      post :mark_as_best, on: :member
    end
  end

  scope :active_storage, module: :active_storage, as: :active_storage do
    resources :attachments, only: [:destroy]
  end

  root to: "questions#index"
  resources :links, only: :destroy
  resources :rewards, only: :index
  
end
