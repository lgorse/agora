class MotionsController < ApplicationController

before_filter :authenticate

	def create
		@motion = Motion.create(:created_by => @current_user.id, 
							  :account_id => @current_user.account.id, 
							  :expires_at => Time.now.since(5.minutes),
							  :threshold => 5,
							  :title => "It\'s too noisy here!",
							  :details => 'It\'s too noisy here!')
	end

	def destroy
		
	end

	def new
		@motion = Motion.new
	end
end
