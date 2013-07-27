class MotionUsersController < ApplicationController
	include MotionUsersHelper

	before_filter :authenticate

	def create
		@motion = Motion.find(params[:motion_user][:motion_id])
		@current_user.vote(@motion)
	end

	def destroy
		@motion = MotionUser.find(params[:id]).motion
		@current_user.unvote(@motion)
	end

end
