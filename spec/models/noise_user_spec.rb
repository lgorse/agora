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
		@noise = FactoryGirl.create(:noise, :threshold => 2)
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
		

		it "should check if the threshold is met" do
			noise_user = FactoryGirl.build(:noise_user, :noise_id => @noise.id)
			noise_user.noise.should_receive(:threshold_met?)
			noise_user.save!
		end

		it "should send an e-mail if threshold is met" do
			while @noise.users.count <= (@noise.threshold - 1)
				new_user = FactoryGirl.create(:user, :account_id => @user.account_id)
				new_user.join(@noise)
			end
			noise_user = FactoryGirl.build(:noise_user, :user_id => 300, :noise_id => @noise.id)
			noise_user.noise.should_receive(:send_email)
			noise_user.save!
		end

	end

	
end
