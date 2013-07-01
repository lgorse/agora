# == Schema Information
#
# Table name: motion_users
#
#  id         :integer          not null, primary key
#  motion_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe MotionUser do
  	before(:each) do
		@user = FactoryGirl.create(:user)
		@motion = FactoryGirl.create(:motion, :threshold => 2)
		@attr = {:motion_id => @motion.id, :user_id => @user.id}
	end

	describe "relationships" do
		before(:each) do
			@motion_users = MotionUser.create(@attr)

		end

		it "should have a user attribute" do
			@motion_users.should respond_to(:user)

		end

		it "should have a motion attribute" do
			@motion_users.should respond_to(:motion)
		end

	end

	describe "validations" do

		it "should have a user id" do
			motion_user = MotionUser.new(@attr.merge(:user_id => ""))
			motion_user.should_not be_valid

		end

		it "should have a motion id" do
			motion_user = MotionUser.new(@attr.merge(:user_id => ""))
			motion_user.should_not be_valid
		end

	end

	describe "create" do
		

		it "should check if the threshold is met" do
			motion_user = FactoryGirl.build(:motion_user, :motion_id => @motion.id)
			motion_user.motion.should_receive(:threshold_met?)
			motion_user.save!
		end

		it "should send an e-mail if threshold is met" do
			while @motion.users.count <= (@motion.threshold - 1)
				new_user = FactoryGirl.create(:user, :account_id => @user.account_id)
				new_user.join(@motion)
			end
			motion_user = FactoryGirl.build(:motion_user, :user_id => 300, :motion_id => @motion.id)
			motion_user.motion.should_receive(:send_email)
			motion_user.save!
		end

	end

	
end
