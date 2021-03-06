class SessionsController < ApplicationController
	

	def new
		redirect_to motions_path if session[:user_id]
	end

	def create
		user_email = params[:session][:email]
		@user = User.find_by_email(user_email.downcase)
		if @user
			signin_user
			redirect_to motions_path
		else
			flash.now[:error] = "Invalid email."
			render "new"
		end
	end

	def destroy
		reset_session
		redirect_to root_path
	end
end
