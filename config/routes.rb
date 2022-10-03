Rails.application.routes.draw do
  resources :books
  resources :campaigns do
    resources :donations
  end

  resources :donors

  root 'campaigns#index'
end
