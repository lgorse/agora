class UsersController < ApplicationController
	include SessionsHelper
	require 'csv'
	
	before_filter :authenticate, :except => [:create_batch_members]
	before_filter :authenticate_admin, :only => [:create_batch_members]

	def create_batch_members
		@account = Account.find(params[:account_id])
		@new_user_list = User.create_from_csv(params[:csv], @account)
		if @new_user_list
			@main_message = "Upload successful"
		else
			@main_message = "General error."
		end
	end


end
