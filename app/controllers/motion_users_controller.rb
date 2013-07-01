class MotionUsersController < ApplicationController
	include MotionUsersHelper

	before_filter :authenticate

	def create
		@current_user.join(Motion.find(params[:motion_user][:motion_id]))
	end

	def destroy
		@current_user.unjoin(Motion.find(params[:id]))
	end

end
