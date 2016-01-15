Rails.application.routes.draw do
  resources :work_assignments
  resources :organizations
  resources :contacts

  devise_for :users

  resources :students do
    member do
      get 'work', :defaults => { :format => :json }
    end
  end

  resources :work_assignments do
    member do
      get 'org', :defaults => { :format => :json }
    end
  end
  root 'students#index'

end
