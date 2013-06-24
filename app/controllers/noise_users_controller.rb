class NoiseUsersController < ApplicationController

	before_filter :authenticate

	def create
		@current_user.join(Noise.find(params[:noise_user][:noise_id]))
	end

	def destroy
		@current_user.unjoin(Noise.find(params[:id]))
	end

end
