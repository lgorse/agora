class UsersController < ApplicationController
	
	before_filter :authenticate

	def show
		@motion = Motion.new
	end
end
