require "spec_helper"

describe UserMailer do

	describe "send e-mail" do
	before(:each) do
		@user = FactoryGirl.create(:user)
		@invitee_email = "test@invitee.com"
		@user.invite(@invitee_email, @user.default_account)
		@mailer = UserMailer.invite_email(@user.invitations.first.id)
		@mailer.deliver
	end

	it "should send an e-mail" do
		ActionMailer::Base.deliveries.should_not be_blank

	end

	it "should send an e-mail to the invitee e-mail" do
		ActionMailer::Base.deliveries.last.to.should ==  [@invitee_email]
	end

end



end
