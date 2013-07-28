class UserMailer < ActionMailer::Base
  
  def invite_email(invitation_id)
  	@invitation = Invitation.find(invitation_id)
  	@inviter = User.find(@invitation.inviter_id)
  	@account = Account.find(@invitation.account_id)
  	@message = @invitation.message
  	mail(:to => @invitation.email,  :subject => "#{@inviter.name} invited you to join #{@account.name} on Agora")
  end
end
