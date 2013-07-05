# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  email      :string(255)
#  team       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  admin      :boolean          default(FALSE)
#

require 'spec_helper'

describe User do

	describe "validation" do
		before(:each) do
			@account = FactoryGirl.create(:account)
			@attr = {:name => "tester", :email => "test@tester.com", :team => "team", :admin => false, :account_id => @account.id}
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

	describe "method joined?" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion, :account_id => @user.id)
		end

		it "should be true if the user has joined the motion" do
			@user.join(@motion)
			@user.joined?(@motion).should == true
		end

		it "should be false if the user has not joined the motion" do
			@user.joined?(@motion).should == false

		end

	end

	describe "method create_from_csv" do
		before(:each) do
			file = File.open('/home/lgorse/www/agora/doc/sample.csv')
			@file_path = ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file))
			@account = FactoryGirl.create(:account)
		end

		it "should create a user if the file is properly formed" do
			lambda do
				User.create_from_csv(@file_path, @account)
			end.should change(User, :count).by(2)

		end

		# it "should go through the users even if one user is not properly formed" do
		# 	bad_file = File.open('/home/lgorse/www/agora/doc/bad_sample.csv')
		# 	bad_file_path = ActionDispatch::Http::UploadedFile.new(:tempfile => bad_file, :filename => File.basename(bad_file))
		# 	lambda do
		# 		User.create_from_csv(bad_file_path, @account)
		# 	end.should change(User, :count).by(1)
		# end

		it "should return the list of new users" do
			user_list = User.create_from_csv(@file_path, @account)
			user_list.count.should == 2
		end

	end


end
