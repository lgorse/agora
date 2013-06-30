Agora::Application.routes.draw do

	root :to => 'sessions#new'

	resources :accounts, :users, :motions, :motion_users

	resources :sessions do
		collection do
			get 'signin'
		end
	end

	match '/logout' => 'sessions#destroy'


end
