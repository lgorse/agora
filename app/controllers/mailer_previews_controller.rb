class MailerPreviewsController < ApplicationController

	def preview_motion_mail
		@user = User.last
		@motion = Motion.last
		render :file => 'motion_mailer/motion_email.html.erb', :layout => 'mailer'
	end
end
