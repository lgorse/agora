module SessionsHelper

	def authenticate
		@current_user = User.find_by_id(session[:user_id])
	end

	def authenticate_admin
		authenticate
		redirect_to root_path unless @current_user.admin? 
	end

	def authenticate_account_match
		authenticate
		authenticate_admin
		redirect_to root_path unless @current_user.account == Account.find(params[:id])
	end
end
