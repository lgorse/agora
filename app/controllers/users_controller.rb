class UsersController < ApplicationController
	include SessionsHelper
	require 'csv'
	
	before_filter :authenticate, :except => [:create_batch_members, :new, :create]
	before_filter :authenticate_admin, :only => [:create_batch_members, :new_admin]

	def create_batch_members
		@account = Account.find(params[:account_id])
		@new_user_list = User.create_from_csv(params[:csv], @account)
		if @new_user_list
			@main_message = "Upload successful"
		else
			@main_message = "General error."
		end
	end

	def new_admin
		@user = User.new
	end

	def new
		@user = User.new
	end

	def create_by_admin
		@user = User.new(:name => params[:user][:name],
						 :default_account => params[:user][:account],
						 :team => params[:user][:team], 
						 :email => params[:user][:email])
		if @user.save
			redirect_to user_path(@user)
		else
			render 'new'
		end
	end

	def create
		@user = User.new
		@invitation = Invitation.find_by_email(params[:user][:email].downcase)
		if @invitation
			@user.attributes = {:name => params[:user][:name],
							 :default_account => @invitation.account_id,
							 :email => params[:user][:email]}
			if @user.save
				signin_user
				redirect_to root_path

			else
				render 'new'
			end

		else
			@user.errors.add(:base, "#{params[:user][:email]} has not been invited")
			render 'new'
		end

	end

	

	def show
		@user = User.find(params[:id])
	end

	def update
		if @current_user.update_attributes(params[:user])
			redirect_to @current_user
		else
			render 'edit'
		end

	end

	def edit
		@user = User.find(params[:id])
	end

	def created
		@user = User.find(params[:id])
		@user_created_motions = @user.created_motions
	end

	def motions
		@user = User.find(params[:id])
		@user_joined_motions = @user.motions
	end


end
