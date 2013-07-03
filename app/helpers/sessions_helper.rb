module SessionsHelper

	def authenticate
		@current_user = User.find_by_id(session[:user_id])
	end

	def authenticate_admin
		authenticate
		redirect_to root_path unless @current_user.admin?

	end
end
