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
      
      match "/sign_in" => "caseadilla_user_sessions#new", via: :get
      # resource :password_reset, :only => [:create, :edit, :update]
    end
        
    match "/blank" => "caseadilla#blank", :via => :get
    root :to => "caseadilla#index"
  end
  
end