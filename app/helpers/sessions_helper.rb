module SessionsHelper

	def authenticate
		begin
			@current_user = User.find(session[:user_id])
			@account = Account.find(session[:account_id])
		rescue
			session[:user_id] = nil
			session[:account_id] = nil
			redirect_to root_path
		end
	end

	def authenticate_admin
		authenticate
		redirect_to root_path unless @current_user.admin? 
	end

	def authenticate_account_match
		authenticate
		authenticate_admin
		redirect_to root_path unless @account == Account.find(params[:id])
	end
end
