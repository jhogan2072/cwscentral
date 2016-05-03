Rails.application.routes.draw do

  root 'van_routes#index'

  devise_for :users

  resources :contacts do
    member do
      get :incidents, :defaults => { :format => :json }
      get :placements, defaults: {format: :json}
    end
  end

  resources :drivers, except: [:show]

  resources :exports do
    collection do
      get :student
    end
  end

  resources :incidents do
    collection do
      get :students
      get :organizations
      get :contacts
      get :add
      get :export
    end
  end

  resources :organizations do
    member do
      get :incidents, :defaults => { :format => :json }
      get :placements, :defaults => { :format => :json }
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

  resources :students do
    member do
      get :incidents, :defaults => { :format => :json }
      get :placements, :defaults => { :format => :json }
    end
  end

  resources :van_routes do
    member do
      get :export, defaults: { :format => :xlsx }
    end
    collection do
      get :copy
    end
  end

  resources :vans, except: [:show]
end
