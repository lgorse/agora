require "spec_helper"

describe NoiseMailer do
  
  describe "send email" do
  	before(:each) do
  		@user = FactoryGirl.create(:user)
  	end

  	it "should send an e-mail" do
  		NoiseMailer.noise_email(@user).deliver
  		ActionMailer::Base.deliveries.should_not be_blank
  	end

  	it "should send an e-mail to the user" do
  		NoiseMailer.noise_email(@user).deliver
  		ActionMailer::Base.deliveries.last.to.should == [@user.email]

  	end

  	it "should have the user's name in the body" do
  		@mailer = NoiseMailer.noise_email(@user)
  		@mailer.body.should have_content(@user.name)
  	end

  end
end
