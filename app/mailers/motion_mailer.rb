class MotionMailer < ActionMailer::Base
  default from: "lgorse@mac.com"

  def motion_email(user)
  	@user = user
  	mail(:to => @user.email,  :subject => "Hello, world")
  end
end
