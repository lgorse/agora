class MotionsController < ApplicationController
	include AccountsHelper, MotionsHelper
	
	before_filter :authenticate

	def create
		@motion = Motion.new(:created_by => @current_user.id, 
			:account_id => session[:account_id], 
			:expires_at => params[:motion][:expires_at],
			:title => params[:motion][:title],
			:details => params[:motion][:details])
		if @motion.save
			redirect_to new_invitation_path(:motion => "sent")
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
		@motion = Motion.new
		@active_motions = @account.active_motions	
	end

	def show
		@motion = Motion.find(params[:id])
	end

	def expired
		@motion = Motion.new
		@expired_motions = @account.expired_motions.reverse
	end
end
