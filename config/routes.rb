Rails.application.routes.draw do

  match "/admin" => redirect("/caseadilla"), :via => :get

  namespace :caseadilla do

    if Caseadilla::Engine.flavor = :steak
      resources :users do
        member do
          get :change_password
          # patch :update_password, :reset_password
        end
      end
      resources :roles

      get "/sign_in", to: "caseadilla_user_sessions#new"
      # resource :password_reset, :only => [:create, :edit, :update]
    end

    get "/blank", to: "caseadilla#blank"
    get '/', to: 'caseadilla#index', as: 'index'

    root "caseadilla#index", as: 'root'
  end

end
