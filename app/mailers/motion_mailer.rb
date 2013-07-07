class MotionMailer < ActionMailer::Base
  default from: "lgorse@mac.com"

  def motion_email(user, motion)
  	@user = user
  	@motion = motion
  	mail(:to => @user.email,  :subject => @motion.title)
  end
end
