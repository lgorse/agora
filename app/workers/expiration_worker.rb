class ExpirationWorker
	include Sidekiq::Worker

	def perform(motion_id)
		motion = Motion.find(motion_id)
	end

end