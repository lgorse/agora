class AccountsController < ApplicationController
	

	before_filter :authenticate_account_match
	
	def show
		
	end

	def batch_members
		
	end

	def email_members_form

	end

	def email_members
		@account.email_members(params[:text], params[:subject])
		redirect_to(@account)
	end

end
