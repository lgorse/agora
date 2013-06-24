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

		it "should have a noise attribute" do
			@user.should respond_to(:noises)
		end

		it "should join a noise" do
			@noise = FactoryGirl.create(:noise)
			lambda do
				@user.join(@noise)
			end.should change(NoiseUser, :count).by(1)
		end

		it "should not join the same noise twice" do
			@noise = FactoryGirl.create(:noise)
			@user.join(@noise)
			@user.join(@noise).should_not be_valid
		end

		it "should unjoin a noise" do
			@noise = FactoryGirl.create(:noise)
			@user.join(@noise)
			lambda do
				@user.unjoin(@noise)
			end.should change(NoiseUser, :count).by(-1)
		end

	end

	describe "method current_noise" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@noise = FactoryGirl.create(:noise)
		end

		it "should respond to a current_noise method" do
			@user.join(@noise)
			@user.should respond_to(:current_noise)
		end

		it "should return the current noise if there is one" do
			@user.join(@noise)
			@user.current_noise.should == @noise

		end

		it "should return nil if there is none" do
			@user.current_noise.should == nil
		end


	end
end
