module MotionUsersHelper

	def reset_motion_variables
		if @current_user.account.active_motion
			@motion = @current_user.account.active_motion
		else
			@motion = Motion.new
		end

	end
end
