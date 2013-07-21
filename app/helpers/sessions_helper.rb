module SessionsHelper

	def authenticate
		begin
			@current_user = User.find(session[:user_id])
		rescue
			session[:user_id] = nil
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
		if @current_user.account == Account.find(params[:id])
			@account = @current_user.account
		else
			redirect_to root_path
		end
	end
end
