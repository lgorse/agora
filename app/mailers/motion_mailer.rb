class MotionMailer < ActionMailer::Base
  default from: "lgorse@mac.com"

  def motion_email(user, motion)
  	@user = user
  	@motion = motion
  	mail(:to => @user.email,  :subject => @motion.title)
  end

  def notification_email(user, motion)
  	@user = user
  	@motion = motion
  	mail(:to => @user.email, :subject => "AGORA: a new motion has been created")
  end
end
