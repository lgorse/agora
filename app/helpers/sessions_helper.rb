module SessionsHelper

	def authenticate
		begin
			@current_user = User.find(session[:user_id])
			@account = Account.find(session[:account_id])
		rescue
			reset_session
			redirect_to root_path and return
		end
	end

	def authenticate_admin
		authenticate
		redirect_to root_path unless @current_user.admin? 
	end

	def signin_user
		session[:user_id] = @user.id
		session[:account_id] = @user.default_account
		cookies[:flash] = "flash me"
	end

	def authenticate_account_match
		authenticate
		redirect_to root_path unless @account == Account.find(params[:id])
	end

	def authenticate_account_match_for_admin
		authenticate
		authenticate_admin
		redirect_to root_path unless @account == Account.find(params[:id])
	end

	def store_location
		session[:return_to] = request.url
	end
end
