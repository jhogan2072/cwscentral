Rails.application.routes.draw do

  root 'students#index'
  resources :organizations
  resources :contacts
  resources :vans
  resources :drivers
  resources :van_routes

  devise_for :users

  resources :students do
    member do
      get :work, :defaults => { :format => :json }
    end
  end

  resources :organizations do
    member do
      get :work, :defaults => { :format => :json }
    end
  end

  resources :work_assignments do
    member do
      get :org, :defaults => { :format => :json }
    end
  end

  resources :exports do
    collection do
      get :student
    end
  end

end
