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
	
end
