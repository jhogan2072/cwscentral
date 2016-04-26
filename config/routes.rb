Rails.application.routes.draw do

  root 'van_routes#index'
  resources :contacts
  resources :vans, except: [:show]
  resources :drivers, except: [:show]

  devise_for :users

  resources :students do
    member do
      get :work, :defaults => { :format => :json }
    end
    collection do
      get :student_placements
    end
  end

  resources :organizations do
    member do
      get :work, :defaults => { :format => :json }
    end
    collection do
      get :organization_placements
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

  resources :work_assignments, except: [:index, :show, :new] do
    member do
      get :org, :defaults => { :format => :json }
    end
    collection do
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
