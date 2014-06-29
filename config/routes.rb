Rails.application.routes.draw do
  
  match "/admin" => redirect("/caseadilla"), :via => :get
  
  namespace :caseadilla do
  
    # if Caseadilla::Engine.flavor = :steak
    #   resources :users do
    #     member do
    #       patch :update_password, :reset_password
    #     end
    #   end
      
    #   resource :user_session
    #   resource :password_reset, :only => [:create, :edit, :update]
    # end
        
    match "/blank" => "caseadilla#blank", :via => :get
    root :to => "caseadilla#index"
  end
  
end