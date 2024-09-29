Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  devise_scope :user do
    authenticated :user do
      root to: 'dashboard#index', as: :authenticated_root
    end
    
    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  root to: 'dashboard#index'
  resources :dogs
  resources :dog_schedules
  resources :shifts do
    member do
      patch :reassign_dog, defaults: { format: :turbo_stream }
      patch :unassign_dog, defaults: { format: :turbo_stream }
    end
  end
  resources :users
  resources :vans

  get 'dog_schedules/:id/edit_status', to: 'dog_schedules#edit_status', as: :edit_dog_schedule_status
  patch 'dog_schedules/:id/update_status', to: 'dog_schedules#update_status', as: :update_dog_schedule_status
end
