class NoiseMailer < ActionMailer::Base
  default from: "lgorse@mac.com"

  def noise_email(user)
  	@user = user
  	mail(:to => @user.email,  :subject => "Hello, world")
  end
end
