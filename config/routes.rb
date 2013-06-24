Agora::Application.routes.draw do

	root :to => 'sessions#new'

	resources :accounts, :users, :noises, :noise_users

	resources :sessions do
		collection do
			get 'signin'
		end
	end

	match '/logout' => 'sessions#destroy'


end
