require "spec_helper"

describe AccountMailer do
  

  describe "user_emails" do
  	before(:each) do
  		@account = FactoryGirl.create(:account)
  		@user =FactoryGirl.create(:user, :account_id => @account.id)
  		@text = "testing"
  		@mailer = AccountMailer.account_user_email(@user, @text)
  		@mailer.deliver
  	end

  	it 'should send an e-mail to users' do
  		ActionMailer::Base.deliveries.last.to.should == [@user.email]
  	end


  end
end
