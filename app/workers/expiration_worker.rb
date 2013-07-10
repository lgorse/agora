class ExpirationWorker
	include Sidekiq::Worker

	def perform(motion_id)
		motion = Motion.find(motion_id)
		motion.check_threshold_and_send_email
	end

end