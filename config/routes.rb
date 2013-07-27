Agora::Application.routes.draw do

	root :to => 'sessions#new'

	resources :motion_users


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
			get :batch_members, :email_members_form
			post :email_members
		end

		collection do
			post :change

		end

	end

	resources :pages, :only => [] do
		collection do
			get 'faq'
		end
	end

	resources :mailer_previews do
		collection do
			get :preview_motion_mail, :preview_notification_mail, :preview_account_user_email
		end
	end

	
	match '/logout' => 'sessions#destroy'
	match '/faq' => 'pages#faq'
	match '/motions' => 'motions#current'

end
