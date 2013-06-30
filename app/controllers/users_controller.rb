class UsersController < ApplicationController
	
	before_filter :authenticate

	def show
		if @current_user.account.has_active_motion
			@motion = @current_user.account.active_motion
		else
			@motion = Motion.new
		end
	end
end
