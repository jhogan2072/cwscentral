Rails.application.routes.draw do
  resources :organizations
  resources :contacts

  devise_for :users

  resources :students do
    member do
      get :work, :defaults => { :format => :json }
    end
  end

  resources :van_routes

  resources :work_assignments do
    member do
      get :org, :defaults => { :format => :json }
    end
  end
  root 'students#index'

  resources :exports do
    collection do
      get :student
    end
  end

end
