# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  email      :string(255)
#  team       :string(255)
#  admin      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

	describe "validation" do
		before(:each) do
			@account = FactoryGirl.create(:account)
			@attr = {:name => "tester", :email => "test@tester.com", :team => "team", :admin => 0, :account_id => @account.id}
		end

		it "must have an account number" do
			user = User.new(@attr.merge(:account_id => nil))
			user.should_not be_valid
		end

		it "must have a name" do
			user = User.new(@attr.merge(:name => ""))
			user.should_not be_valid
		end

		it "must have an e-mail" do
			user = User.new(@attr.merge(:email => ""))
			user.should_not be_valid
		end

		it "should have a properly formed e-mail" do
			addresses = ["test@test", "test.test", "test@test."]
			addresses.each do |address|
				user = User.new(@attr.merge(:email => address))
				user.should_not be_valid
			end
		end

		it "must have a unique e-mail" do
			user =  User.create!(@attr)
			user2 = User.new(@attr)
			user2.should_not be_valid
		end

		it "should not be case sensitive" do
			user = User.create!(@attr)
			user2 = User.new(@attr.merge(:email => "TEST@TESTER.COM"))
			user2.should_not be_valid

		end

	end

	describe "associations" do
		before(:each) do
			@user = FactoryGirl.create(:user)

		end

		it "should have an account attribute" do
			@user.should respond_to(:account)
		end

		it "should have a motion attribute" do
			@user.should respond_to(:motions)
		end

		it "should join a motion" do
			@motion = FactoryGirl.create(:motion)
			lambda do
				@user.join(@motion)
			end.should change(MotionUser, :count).by(1)
		end

		it "should not join the same motion twice" do
			@motion = FactoryGirl.create(:motion)
			@user.join(@motion)
			@user.join(@motion).should_not be_valid
		end

		it "should unjoin a motion" do
			@motion = FactoryGirl.create(:motion)
			@user.join(@motion)
			lambda do
				@user.unjoin(@motion)
			end.should change(MotionUser, :count).by(-1)
		end

	end

	describe "method current_motion" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion)
		end

		it "should respond to a current_motion method" do
			@user.join(@motion)
			@user.should respond_to(:current_motion)
		end

		it "should return the current motion if there is one" do
			@user.join(@motion)
			@user.current_motion.should == @motion

		end

		it "should return nil if there is none" do
			@user.current_motion.should == nil
		end


	end
end
