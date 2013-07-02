class MotionsController < ApplicationController
	include AccountsHelper
	
	before_filter :authenticate

	def create
		@motion = Motion.new(:created_by => @current_user.id, 
			:account_id => @current_user.account.id, 
			:expires_at => Time.now.since(3.hours),
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
		@active_motions = @current_user.account.active_motions		
	end

	def show
		@motion = Motion.find(params[:id])

	end

	def current
		@active_motions = @current_user.account.active_motions
	end

	def expired
		@expired_motions = @current_user.account.past_motions.reverse
	end
end
