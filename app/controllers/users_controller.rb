class UsersController < ApplicationController
	
	before_filter :authenticate

	def show
		if @current_user.account.has_active_noise
			@noise = @current_user.account.active_noise
		else
			@noise = Noise.new
		end
	end
end
