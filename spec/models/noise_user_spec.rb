# == Schema Information
#
# Table name: noise_users
#
#  id         :integer          not null, primary key
#  noise_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe NoiseUser do
  	before(:each) do
		@user = FactoryGirl.create(:user)
		@noise = FactoryGirl.create(:noise)
		@attr = {:noise_id => @noise.id, :user_id => @user.id}
	end

	describe "relationships" do
		before(:each) do
			@noise_users = NoiseUser.create(@attr)

		end

		it "should have a user attribute" do
			@noise_users.should respond_to(:user)

		end

		it "should have a noise attribute" do
			@noise_users.should respond_to(:noise)
		end

	end

	describe "validations" do

		it "should have a user id" do
			noise_user = NoiseUser.new(@attr.merge(:user_id => ""))
			noise_user.should_not be_valid

		end

		it "should have a noise id" do
			noise_user = NoiseUser.new(@attr.merge(:user_id => ""))
			noise_user.should_not be_valid
		end

	end

	describe "create" do

		it "should have a check_threshold method" do
			noise_user = NoiseUser.create(@attr)

		end

		it "should check if the threshold is met" do
			


		end

	end

	
end
