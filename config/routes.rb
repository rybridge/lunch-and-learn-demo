Rails.application.routes.draw do
  root 'users#index'

  resources :users do
    resource :introduction_emails, only: [:create], path: 'introduction-email'
  end
end
