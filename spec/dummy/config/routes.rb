Rails.application.routes.draw do

	#Caseadilla routes
	namespace :caseadilla do
		resources :posts
	end

  resources :posts
  devise_for :users
  resources :users

  root 'posts#index'

  mount Caseadilla::Engine => "/caseadilla"
end
