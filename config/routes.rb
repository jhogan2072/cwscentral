Rails.application.routes.draw do

  root 'van_routes#index'

  devise_for :users
  scope "/admin" do
    resources :users, except: [:show]
  end

  resources :merges, except: [:show, :update, :destroy, :index, :new, :edit, :create] do
    collection do
      get :merge_organizations
      post :org_merge
      get :autocomplete_organization_name
    end
  end

  resources :contacts, except: [:show] do
    member do
      get :incidents, :defaults => { :format => :json }
      get :placements, defaults: {format: :json}
    end
    collection do
      get :mailing_lists
      post :list_export, defaults: { :format => :xlsx }
      get :export, defaults: { :format => :xlsx }
      get :import
      post :import
      post :commit
    end
  end

  resources :contact_stagings, only: [:edit, :update, :destroy]

  resources :contact_assignments, only: [:show, :index, :update], :defaults => { :format => :json } do
    collection do
      get :reopen
    end
  end

  resources :drivers, except: [:show]

  resources :exports do
    collection do
      get :student
    end
  end

  resources :incident_categories, except: [:show]

  resources :incidents, except: [:index, :show] do
    collection do
      get :students
      get :organizations
      get :contacts
      get :export, defaults: { :format => :xlsx }
    end
  end

  resources :organizations do
    member do
      get :incidents, :defaults => { :format => :json }
      get :placements, :defaults => { :format => :json }
    end
    collection do
      get :export, defaults: { :format => :xlsx }
      get :import
      post :import
      post :commit
    end
  end

  resources :org_stagings, only: [:edit, :update, :destroy]

  resources :placements, except: [:index, :show, :new] do
    member do
      get :org, :defaults => { :format => :json }
      get :edit_contact
      post :update_contact
    end
    collection do
      post :export_attendance, defaults: { :format => :xlsx }
      get :attendance
      get :students
      get :organizations
      get :contacts
      get :add
      get :export, defaults: { :format => :xlsx }
      get :import
      post :import
      post :commit
    end
  end

  resources :placement_stagings, only: [:edit, :update, :destroy]

  resources :students, except: [:show] do
    member do
      get :export, defaults: { :format => :xlsx }
      get :incidents, :defaults => { :format => :json }
      get :placements, :defaults => { :format => :json }
    end
    collection do
      get :active
      get :export_all, defaults: {:format => :xlsx }
      get :import
      post :import
      post :commit
    end
  end

  resources :students_stagings, only: [:edit, :update, :destroy]

  resources :van_routes do
    member do
      get :export, defaults: { :format => :xlsx }
    end
    collection do
      get :autocomplete_placement_org_contact_student
      get :copy, :defaults => { :format => :json }
      get :export_all, defaults: { :format => :xlsx }
      get :prior_days, :defaults => { :format => :json }
    end
  end

  resources :vans, except: [:show] do
    collection do
      get :export, defaults: { :format => :xlsx }
    end
  end
end
