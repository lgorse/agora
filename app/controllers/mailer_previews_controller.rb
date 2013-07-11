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
end
