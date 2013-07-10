# == Schema Information
#
# Table name: motions
#
#  id         :integer          not null, primary key
#  created_by :integer
#  account_id :integer
#  threshold  :integer
#  details    :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email_sent :boolean          default(FALSE)
#  expires_at :datetime
#  email_time :datetime
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

		it "must be ordered by expiration date" do
			motion1 = FactoryGirl.create(:motion, :account_id => @user.account_id, :expires_at => Time.now.since(5.minutes))
			motion2 = FactoryGirl.create(:motion, :account_id => @user.account_id, :expires_at => Time.now.since(2.minutes))
			Motion.first.should == motion2

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

	describe "current?" do
		before(:each) do
			@motion = FactoryGirl.create(:motion)
		end

		it "should respond to a current? method" do
			@motion.should respond_to(:current?)

		end

		it "should return true if the motion has not expired yet" do
			@motion.current?.should == true
		end

		it "should return false if the motion has expired" do
			motion = FactoryGirl.create(:motion, :expires_at => Time.now.since(1.seconds))
			new_time = Time.now.since(5.minutes)
			Timecop.freeze(new_time)
			motion.current?.should == false
		end

	end


	describe "e-mail" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user, :account_id => @user.account_id)
			@motion = FactoryGirl.create(:motion, :account_id => @user.account_id, :threshold => 2)
			@user.join(@motion)
		end

		it "should have a send_email method" do
			@motion.should respond_to(:send_email)
		end

		it "should send an e-mail to every user in the account" do
			lambda do
			@motion.send_email
		end.should change(ActionMailer::Base.deliveries, :count).by(@motion.account.users.count)
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

	describe "delayed e-mail job" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "should add the e-mail send to the queue" do
			lambda do
				@motion = FactoryGirl.create(:motion, :account_id => @user.account_id, 
											 :created_by => @user.id, :threshold => 2)
			end.should change(ExpirationWorker.jobs, :size).by(1)
		end

		it "should time the e-mail to the expires_at value of the motion" do
			@motion = FactoryGirl.create(:motion, :account_id => @user.account_id, 
											 :created_by => @user.id, :threshold => 2)
			ExpirationWorker.should have_queued_job_at(@motion.expires_at, 1)

		end

		describe "when executed" do
			before(:each) do
				@user2 = FactoryGirl.create(:user, :account_id => @user.account_id)
				@motion = FactoryGirl.create(:motion, :account_id => @user.account_id, 
											 :created_by => @user.id, :threshold => 2)
				@email_sender = ExpirationWorker.new
			end

			it "should send an e-mail if the threshold is met" do
				@user2.join(@motion)
				lambda do
					@email_sender.perform(@motion.id)
				end.should change(ActionMailer::Base.deliveries, :count).by(@motion.account.users.count)

			end

			it "should not send an e-mail if the threshold is not met" do
				lambda do
					@email_sender.perform(@motion.id)
				end.should change(ActionMailer::Base.deliveries, :count).by(0)
			end

		end

	end


end
