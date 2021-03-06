class RepliesController < ApplicationController
	before_filter :authenticate

	def new
		@motion = Motion.find(params[:motion])
		@reply = Reply.new
	end

	def create
		@reply = Reply.new(:user_id => @current_user.id, :motion_id => params[:reply][:motion_id],
						   :text => params[:reply][:text])
		@motion = @reply.motion
		render 'motions/index' unless @reply.save
	end

	def destroy
		@reply = Reply.find(params[:id])
		@motion = @reply.motion
		@reply.destroy
	end
end
