class AccountsController < ApplicationController
	

	before_filter :authenticate_account_match, :except => [:change]
	
	
	def show
		
	end

	def batch_members
		
	end

	def email_members_form

	end

	def email_members
		AllUserEmailWorker.perform_async(@account.id, params[:text], params[:subject])
		redirect_to(@account)
	end

	def change
		if account = Account.find_by_id(params[:account_id])
			session[:account_id] = params[:account_id]
			redirect_to motions_path if authenticate
		else
			redirect_to root_path
		end
	end

end
