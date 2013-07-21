class AllUserEmailWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 5

	def perform(account_id, text, subject)
		account = Account.find(account_id)
		account.email_members(text, subject)
	end

end