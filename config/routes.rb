Rails.application.routes.draw do

  root 'van_routes#index'
  resources :vans, except: [:show]
  resources :drivers, except: [:show]

  devise_for :users

  resources :contacts do
    member do
      get :placements, defaults: {format: :json}
    end
  end

  resources :students do
    member do
      get :placements, :defaults => { :format => :json }
    end
  end

  resources :organizations do
    member do
      get :placements, :defaults => { :format => :json }
    end
  end

  resources :van_routes do
    member do
      get :export, defaults: { :format => :xls }
    end
    collection do
      get :copy
    end
  end

  resources :placements, except: [:index, :show, :new] do
    member do
      get :org, :defaults => { :format => :json }
    end
    collection do
      get :students
      get :organizations
      get :contacts
      get :add
      get :export
    end
  end

  resources :exports do
    collection do
      get :student
    end
  end

end
