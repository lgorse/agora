class SessionsController < ApplicationController

	def new
		redirect_to motions_path if session[:user_id]
	end

	def create
		@user = User.find_by_email(params[:session][:email])
		if @user
			session[:user_id] = @user.id
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
