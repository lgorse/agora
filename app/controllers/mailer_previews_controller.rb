class MailerPreviewsController < ApplicationController

	def preview_motion_mail
		@user = User.last
		@motion = Motion.last
		render :file => 'motion_mailer/motion_email.html.erb', :layout => 'mailer'
	end

	def preview_notification_mail
		@user = User.first
		@motion = Motion.last
		render :file => 'motion_mailer/notification_email.html.erb', :layout => 'mailer'
	end

	def preview_account_user_email
		@user = User.first
		@text = "Hello everyone.\n\n I\'m happy to be here."
		render :file => 'account_mailer/account_user_email.html.erb', :layout => 'mailer'
	end

	def preview_invite_email
		@account = Account.first
		@inviter = Account.first.users.first
		@message = "Ulysses is a novel by the Irish writer James Joyce. It was first serialised in parts in the American journal The Little Review from March 1918 to December 1920, and then published in its entirety by Sylvia Beach in February 1922, in Paris. Considered one of the most important works of Modernist literature,[1] it has been called "
		@invitation = Invitation.create(:inviter_id => @inviter.id, :account_id => @account.id, 
										:email => "test@test.com", :message => @message)
		render :file => 'user_mailer/invite_email.html.erb', :layout => 'mailer'
	end
end
