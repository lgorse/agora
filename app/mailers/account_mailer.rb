class AccountMailer < ActionMailer::Base
  default from: "lgorse@mac.com"

  def account_user_email(user, text)
  	@user = user
  	@text = text
  	mail(:to => @user.email, :subject => "News from Agora")

  end
end
