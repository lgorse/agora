class AccountsController < ApplicationController
	

	before_filter :authenticate_admin

	def show
		@account = @current_user.account
	end

	def no_admin

	end

end
