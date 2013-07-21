class AccountMailer < ActionMailer::Base
  default from: "lgorse@mac.com"

  def account_user_email(user, text, subject)
  	@user = user
  	@text = text
  	mail(:to => @user.email, :subject => subject)

  end
end
