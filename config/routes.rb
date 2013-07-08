Agora::Application.routes.draw do

	root :to => 'sessions#new'

	resources :accounts, :users, :motion_users

	resources :motions do
		collection do
			get :expired, :current
		end
	end

	resources :users do
		collection do
			post 'create_batch_members'
		end
		member do
			get 'created', 'motions'

		end

	end

	resources :sessions do
		collection do
			get 'signin'
		end
	end

	resources :accounts do
		member do
			get :batch_members
		end

	end

	resources :pages, :only => [] do
		collection do
			get 'faq'
		end
	end

	match '/logout' => 'sessions#destroy'
	match '/faq' => 'pages#faq'
	match '/motions' => 'motions#current'

end
