# == Schema Information
#
# Table name: noises
#
#  id          :integer          not null, primary key
#  created_by  :integer
#  account_id  :integer
#  threshold   :integer
#  create_text :string(255)
#  agree_text  :string(255)
#  cancel_text :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  email_sent  :boolean          default(FALSE)
#  expires_at  :datetime
#  email_time  :datetime
#



require 'spec_helper'

describe Noise do

	describe "validations" do

		before(:each) do
			@account = FactoryGirl.create(:account)
			@user = FactoryGirl.create(:user)
			@attr = { :created_by => @user.id,
				:account_id => @account.id,
				:expires_at => Time.now.since(5.minutes),
				:threshold => 5,
				:create_text => "Create",
				:agree_text => "Join",
				:cancel_text => "Cancel"
			}
			@text = 'a' * (MAX_BUTTON_TEXT+1)

		end

		it "must be created by a user" do
			noise = Noise.new(@attr.merge(:created_by => ""))
			noise.should_not be_valid
		end

		it "must be linked to an account" do
			noise = Noise.new(@attr.merge(:account_id => ""))
			noise.should_not be_valid
		end

		it "must have an expiration" do
			noise = Noise.new(@attr.merge(:expires_at => ""))
			noise.should_not be_valid
		end

		it "must not expire in the past"  do
			noise = Noise.new(@attr.merge(:expires_at => Time.now.ago(5.minutes)))
			noise.should_not be_valid

		end

		it "must have a threshold" do
			noise = Noise.new(@attr.merge(:threshold => ""))
			noise.should_not be_valid
		end

		it "must have a create_text" do
			noise = Noise.new(@attr.merge(:create_text => ""))
			noise.should_not be_valid
		end

		it "must not exceed the maximum characters" do
			noise = Noise.new(@attr.merge(:create_text => @text))
			noise.should_not be_valid
		end

		it "must have an agree_text" do
			noise = Noise.new(@attr.merge(:agree_text => ""))
			noise.should_not be_valid
		end

		it "must not exceed the maximum characters" do
			noise = Noise.new(@attr.merge(:agree_text => @text))
			noise.should_not be_valid
		end

		it "must have a cancel_text" do
			noise = Noise.new(@attr.merge(:cancel_text => ""))
			noise.should_not be_valid
		end

		it "must not exceed the maximum characters" do
			noise = Noise.new(@attr.merge(:cancel_text => @text))
			noise.should_not be_valid
		end

		it "should not allow a second noise if there is a first one still active" do
			noise1 = FactoryGirl.create(:noise, :account_id => @attr[:account_id])
			noise2 = Noise.new(@attr)
			noise2.should_not be_valid
		end

	end

	describe "associations noise_user" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@noise = FactoryGirl.create(:noise, :created_by => @user.id)
		end

		it "should create a noise relationship with the creator user" do
			noise_user = NoiseUser.find_by_user_id(@user.id)
			noise_user.should_not be_nil
		end


		it "should have a users method" do
			noise_user = NoiseUser.create(:noise_id => @noise.id, :user_id => @user.id)
			@noise.should respond_to(:users)
		end

		it "should have users" do
			noise_user = NoiseUser.create(:noise_id => @noise.id, :user_id => @user.id)
			@noise.users.should include(@user)
		end

		it "must be destroyed if it has 0 users" do
			NoiseUser.destroy_all
			Noise.all.should be_blank
		end

	end

	describe "check threshold" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@noise = FactoryGirl.create(:noise, :account_id => @user.account_id, :threshold => 2)
			@user2 = FactoryGirl.create(:user, :account_id => @user.account_id)
		end

		it "should have a check threshold method" do
			@noise.should respond_to(:threshold_met?)
		end

		it "should return true if the threshold is met" do
			@user.join(@noise)
			#@user2.join(@noise)
			@noise.threshold_met?.should == true
		end

		it "should return false if the threshold is not met" do
			@noise.threshold_met?.should == false
		end


	end

	describe "e-mail" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@noise = FactoryGirl.create(:noise, :account_id => @user.account_id, :threshold => 2)
			@user.join(@noise)
		end

		it "should have a send_email method" do
			@noise.should respond_to(:send_email)
		end

		it "should send an e-mail" do
			@noise.send_email
			ActionMailer::Base.deliveries.last.to.should == [@user.email]
		end

		it "should not send an e-mail if one has already been sent" do
			@noise.send_email
			lambda do
				@noise.send_email
			end.should change(ActionMailer::Base.deliveries, :count).by(0)


		end

		it "should have an e-mail sent attribute" do
			@noise.should respond_to(:email_sent)
		end

		it "should have a email_time attribute" do
			@noise.should respond_to(:email_time)

		end

		it "should have a nil email_time if no e-mail has been sent" do
			@noise.email_time.should == nil
		end

		it "should fill email_time iwth the e-mail time if an e-mail has been sent" do
			Timecop.freeze
			lambda do
				@noise.send_email
			end.should change(@noise, :email_time).from(nil).to(Time.now)

		end

		it "e-mail sent attribute should be true if an e-mail has been sent" do
			@noise.send_email
			@noise.email_sent.should == true

		end

		it "e-mail sent attribute should be false if an e-mail has not been sent" do
			@noise.email_sent.should == false
		end

	end

end
