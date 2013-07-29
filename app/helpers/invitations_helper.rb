module InvitationsHelper

	def parse_emails(email_list)
		valid_emails = []
		invalid_emails = []
		email_list.split(',').each do |email|
			if email.match(EMAIL_FORMAT)
				valid_emails << email
			else
				invalid_emails << email
			end
		end
		[valid_emails, invalid_emails]
	end
end
