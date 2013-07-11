class NewMotionWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 3

	def perform(motion_id)
		motion = Motion.find(motion_id)
		motion.new_motion_email
	end

end