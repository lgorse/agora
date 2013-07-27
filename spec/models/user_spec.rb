# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  default_account :integer
#  name            :string(255)
#  email           :string(255)
#  team            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  admin           :boolean          default(FALSE)
#  email_notify    :boolean          default(TRUE)
#

require 'spec_helper'

describe User do

	describe "validation" do
		before(:each) do
			@account = FactoryGirl.create(:account)
			@attr = {:name => "tester", :email => "test@tester.com", :team => "team", :admin => false, :default_account => @account.id}
		end

		it "must have a name" do
			user = User.new(@attr.merge(:name => ""))
			user.should_not be_valid
		end

		it "must have an e-mail" do
			user = User.new(@attr.merge(:email => ""))
			user.should_not be_valid
		end

		it 'e-mail must always be downcased' do
			up_email = "TEST@TESTER.COM"
			user = User.new(@attr.merge(:email => up_email))
			user.save
			user.email.should == up_email.downcase
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

		it "should set email_notify to true by default" do
			user = User.create!(@attr)
			user.email_notify.should == true
		end

	end

	describe "associations" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "should have an accounts attribute" do
			@user.should respond_to(:accounts)
		end

		it "should have a motion attribute" do
			@user.should respond_to(:motions)
		end


	end

	describe "method create" do
		before(:each) do
			@user = FactoryGirl.build(:user)
		end

		it "should only connect the user to a single account" do
			@user.save
			@user.accounts.count.should == 1

		end

		it "should connect the user to his default account" do
			@user.save
			@user.accounts.first.should == Account.find(@user.default_account)
		end

	end

	describe "method join" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@account2 = FactoryGirl.create(:account)
		end

		it "should identify multiple accounts if the user has them" do
			@user.join(@account2)
			@user.accounts.count.should == 2
		end

		it "should add the account to the user's accounts" do
			@user.join(@account2)
			@user.accounts.should include(@account2)
		end

		it "should not allow the user to join an account twice" do
			@user.join(@account2)
			@user.join(@account2).should_not be_valid
		end

	end

	describe "method joined?" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@account2 = FactoryGirl.create(:account)
		end

		it "should not be the sane as the default acct" do
			default = Account.find(@user.default_account)
			default.should_not == @account2
		end

		it "should be true if the user has joined the account" do
			@user.join(@account2)
			@user.joined?(@account2).should == true
		end

		it "should be false if the user has not joined the account" do
			@user.joined?(@account2).should == false
		end

	end

	describe "method vote" do
		before(:each) do
			@user = FactoryGirl.create(:user)
		end

		it "should vote a motion" do
			@motion = FactoryGirl.create(:motion)
			lambda do
				@user.vote(@motion)
			end.should change(MotionUser, :count).by(1)
		end

		it "should not vote the same motion twice" do
			@motion = FactoryGirl.create(:motion)
			@user.vote(@motion)
			@user.vote(@motion).should_not be_valid
		end

		it "should unvote a motion" do
			@motion = FactoryGirl.create(:motion)
			@user.vote(@motion)
			lambda do
				@user.unvote(@motion)
			end.should change(MotionUser, :count).by(-1)
		end

	end

	describe "method voted?" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion, :account_id => @user.accounts.first.id)
		end

		it "should be true if the user has voted the motion" do
			@user.vote(@motion)
			@user.voted?(@motion).should == true
		end

		it "should be false if the user has not voted the motion" do
			@user.voted?(@motion).should == false

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

	describe "created motions" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion1 = FactoryGirl.create(:motion, 
				:created_by => @user.id, 
				:account_id => @user.accounts.first.id)
			@motion2 = FactoryGirl.create(:motion, 
				:account_id => @user.accounts.first.id)
			@user.vote(@motion2)
		end

		it "should show only the motions created by the user" do
			@user.created_motions.count.should == 1
		end

	end


end
