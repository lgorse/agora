class MotionsController < ApplicationController

before_filter :authenticate

	def create
		@motion = Motion.create(:created_by => @current_user.id, 
							  :account_id => @current_user.account.id, 
							  :expires_at => Time.now.since(3.hours),
							  :threshold => params[:motion][:threshold],
							  :title => params[:motion][:title],
							  :details => params[:motion][:details])
		redirect_to root_path
	end

	def destroy
		
	end

	def new
		@motion = Motion.new
		@member_count = @current_user.account.users.count
	end
end
