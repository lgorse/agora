class MotionsController < ApplicationController
	include AccountsHelper, MotionsHelper
	
	before_filter :authenticate

	def create
		@motion = Motion.new(:created_by => @current_user.id, 
			:account_id => session[:account_id], 
			:expires_at => params[:motion][:expires_at],
			:threshold => params[:motion][:threshold],
			:title => params[:motion][:title],
			:details => params[:motion][:details])
		if @motion.save
			redirect_to root_path
		else
			render 'motions/new'
		end
	end

	def destroy
		
	end

	def new
		@motion = Motion.new
	end

	def index
		@active_motions = @account.active_motions	
	end

	def show
		@motion = Motion.find(params[:id])

	end

	def current
		@active_motions = @account.active_motions

	end

	def expired
		@expired_motions = @account.expired_motions.reverse
	end
end
