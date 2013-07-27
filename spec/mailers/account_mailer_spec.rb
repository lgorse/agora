require "spec_helper"

describe AccountMailer do
  

  describe "user_emails" do
  	before(:each) do
  		@account = FactoryGirl.create(:account)
  		@user =FactoryGirl.create(:user, :default_account => @account.id)
  		@text = "testing"
      @subject = "subjecting"
  		@mailer = AccountMailer.account_user_email(@user, @text, @subject)
  		@mailer.deliver
  	end

  	it 'should send an e-mail to users' do
  		ActionMailer::Base.deliveries.last.to.should == [@user.email]
  	end


  end
end
