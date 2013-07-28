class InviteWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 3

	def perform(invitation_id)
		UserMailer.invite_email(invitation_id).deliver
	end

end