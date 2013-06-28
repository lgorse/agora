module NoiseUsersHelper

	def reset_noise_variables
		if @current_user.account.active_noise
			@noise = @current_user.account.active_noise
		else
			@noise = Noise.new
		end

	end
end
