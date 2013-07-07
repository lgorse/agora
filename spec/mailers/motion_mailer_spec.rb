require "spec_helper"

describe MotionMailer do
  
  describe "send email" do
  	before(:each) do
  		@user = FactoryGirl.create(:user)
      @motion = FactoryGirl.create(:motion, :account_id => @user.account_id)
      @user.join(@motion)
      @mailer = MotionMailer.motion_email(@user, @motion)
      @mailer.deliver
  	end

  	it "should send an e-mail" do
  		ActionMailer::Base.deliveries.should_not be_blank
  	end

  	it "should send an e-mail to the user" do
  		ActionMailer::Base.deliveries.last.to.should == [@user.email]

  	end

  	it "should have the user's e-mail in the to: line" do	
  		@mailer.to.should == [@user.email]
  	end

    it "should have the motion title as a subject" do
      @mailer.subject.should == @motion.title
    end

    it "should have the motion title in the body" do
      @mailer.body.should  match(@motion.details)

    end

  end
end
