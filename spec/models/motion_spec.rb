# == Schema Information
#
# Table name: motions
#
#  id          :integer          not null, primary key
#  created_by  :integer
#  account_id  :integer
#  threshold   :integer
#  create_text :string(255)
#  join_text   :string(255)
#  cancel_text :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email_sent  :boolean          default(FALSE)
#  expires_at  :datetime
#  email_time  :datetime
#



require 'spec_helper'

describe Motion do

	describe "validations" do

		before(:each) do
			@account = FactoryGirl.create(:account)
			@user = FactoryGirl.create(:user)
			@attr = { :created_by => @user.id,
				:account_id => @account.id,
				:expires_at => Time.now.since(5.minutes),
				:threshold => 5,
				:title => "Create",
				:details => "Join",
			}
			@title = 'a' * (TITLE_CHAR_MAX+1)
			@details = 'a' * (DETAILS_CHAR_MAX + 1)
		end

		it "must be created by a user" do
			motion = Motion.new(@attr.merge(:created_by => ""))
			motion.should_not be_valid
		end

		it "must be linked to an account" do
			motion = Motion.new(@attr.merge(:account_id => ""))
			motion.should_not be_valid
		end

		it "must have an expiration" do
			motion = Motion.new(@attr.merge(:expires_at => ""))
			motion.should_not be_valid
		end

		it "must not expire in the past"  do
			motion = Motion.new(@attr.merge(:expires_at => Time.now.ago(5.minutes)))
			motion.should_not be_valid

		end

		it "must have a threshold" do
			motion = Motion.new(@attr.merge(:threshold => ""))
			motion.should_not be_valid
		end

		it "must have a title" do
			motion = Motion.new(@attr.merge(:title => ""))
			motion.should_not be_valid
		end

		it "must not exceed the maximum characters in the title" do
			motion = Motion.new(@attr.merge(:title => @title))
			motion.should_not be_valid
		end


		it "must not exceed the maximum characters in the details" do
			motion = Motion.new(@attr.merge(:details => @details))
			motion.should_not be_valid
		end

	
		it "should not allow a second motion if there is a first one still active" do
			motion1 = FactoryGirl.create(:motion, :account_id => @attr[:account_id])
			motion2 = Motion.new(@attr)
			motion2.should_not be_valid
		end

	end

	describe "associations motion_user" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion, :created_by => @user.id)
		end

		it "should create a motion relationship with the creator user" do
			motion_user = MotionUser.find_by_user_id(@user.id)
			motion_user.should_not be_nil
		end


		it "should have a users method" do
			motion_user = MotionUser.create(:motion_id => @motion.id, :user_id => @user.id)
			@motion.should respond_to(:users)
		end

		it "should have users" do
			motion_user = MotionUser.create(:motion_id => @motion.id, :user_id => @user.id)
			@motion.users.should include(@user)
		end

		it "must be destroyed if it has 0 users" do
			MotionUser.destroy_all
			Motion.all.should be_blank
		end

	end

	describe "check threshold" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion, :account_id => @user.account_id, :threshold => 2)
			@user2 = FactoryGirl.create(:user, :account_id => @user.account_id)
		end

		it "should have a check threshold method" do
			@motion.should respond_to(:threshold_met?)
		end

		it "should return true if the threshold is met" do
			@user.join(@motion)
			#@user2.join(@motion)
			@motion.threshold_met?.should == true
		end

		it "should return false if the threshold is not met" do
			@motion.threshold_met?.should == false
		end


	end

	describe "e-mail" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion, :account_id => @user.account_id, :threshold => 2)
			@user.join(@motion)
		end

		it "should have a send_email method" do
			@motion.should respond_to(:send_email)
		end

		it "should send an e-mail" do
			@motion.send_email
			ActionMailer::Base.deliveries.last.to.should == [@user.email]
		end

		it "should not send an e-mail if one has already been sent" do
			@motion.send_email
			lambda do
				@motion.send_email
			end.should change(ActionMailer::Base.deliveries, :count).by(0)


		end

		it "should have an e-mail sent attribute" do
			@motion.should respond_to(:email_sent)
		end

		it "should have a email_time attribute" do
			@motion.should respond_to(:email_time)

		end

		it "should have a nil email_time if no e-mail has been sent" do
			@motion.email_time.should == nil
		end

		it "should fill email_time iwth the e-mail time if an e-mail has been sent" do
			Timecop.freeze
			lambda do
				@motion.send_email
			end.should change(@motion, :email_time).from(nil).to(Time.now)

		end

		it "e-mail sent attribute should be true if an e-mail has been sent" do
			@motion.send_email
			@motion.email_sent.should == true

		end

		it "e-mail sent attribute should be false if an e-mail has not been sent" do
			@motion.email_sent.should == false
		end

	end

end
