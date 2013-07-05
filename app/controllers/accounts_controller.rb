class AccountsController < ApplicationController
	

	
	before_filter :authenticate_account_match, :only => [:show, :batch_members]

	def show
		@account = @current_user.account
	end

	def batch_members

	end

end
