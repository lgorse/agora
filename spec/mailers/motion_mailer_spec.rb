require "spec_helper"

describe MotionMailer do
  
  describe "send email" do
  	before(:each) do
  		@user = FactoryGirl.create(:user)
  	end

  	it "should send an e-mail" do
  		MotionMailer.motion_email(@user).deliver
  		ActionMailer::Base.deliveries.should_not be_blank
  	end

  	it "should send an e-mail to the user" do
  		MotionMailer.motion_email(@user).deliver
  		ActionMailer::Base.deliveries.last.to.should == [@user.email]

  	end

  	it "should have the user's name in the body" do
  		@mailer = MotionMailer.motion_email(@user)
  		@mailer.body.should have_content(@user.name)
  	end

  end
end
