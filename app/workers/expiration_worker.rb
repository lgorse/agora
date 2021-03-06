class ExpirationWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 5

	def perform(motion_id)
		motion = Motion.find(motion_id)
		motion.send_email
	end

end