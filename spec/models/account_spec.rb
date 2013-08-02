# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'
require 'debugger'

describe Account do

  describe "validations" do

  	it "should prevent two accounts with the same name" do
  		test_account0 = Account.create!(:name => "test_name")
  		test_account1 = Account.new(:name => "test_name")
  		test_account1.should_not be_valid

  	end

  	it "should require a name" do
  		test_account = Account.new(:name => "")
  		test_account.should_not be_valid
  	end

  end

  describe "associations" do
    before(:each) do
      @account = FactoryGirl.create(:account)
      #@user = FactoryGirl.create(:user, :account => @account.id)
    end

    it "should have a users attribute" do
      @account.should respond_to(:users)
    end

    it "should have a motion attribute" do
      @account.should respond_to(:motions)
    end

    it "should have the correct motion attribute" do
      @motion = FactoryGirl.create(:motion, :account_id => @account.id)
      @account.motions.first.should == @motion
    end

    it "should destroy all motions if destroyed" do
      @motion = FactoryGirl.create(:motion, :account_id => @account.id)
      @account.destroy
      Motion.find_by_id(@motion.id).should be_nil
    end

    it 'should have an invitations attribute' do
      @account.should respond_to(:invitations)
    end

  end

  describe "has active motion" do
    before(:each) do
      @account = FactoryGirl.create(:account)
      
    end

    it 'should return true if there is an active motion' do
      @motion = FactoryGirl.create(:motion, :account_id =>  @account.id)
      @account.has_active_motions.should == true
    end

    it 'should return false if there is not an active motion ' do
      @account.has_active_motions.should == false

    end

  end

  
  describe "active motions" do
    before(:each) do
      @account = FactoryGirl.create(:account)
      @motion_active = FactoryGirl.create(:motion, :expires_at => Time.now.since(10.minutes), :account_id => @account.id)
      @motion_expired = FactoryGirl.create(:motion, :expires_at => Time.now.since(1.seconds), :account_id => @account.id)
      new_time = Time.now.since(5.minutes)
      Timecop.freeze(new_time)
    end

    it "should respond to an active_motions method" do
      @account.should respond_to(:active_motions)

    end

    it "should contain only the active motions" do
      @account.active_motions.should_not include(@motion_expired)
    end

  end

  describe "expired motions" do
    before(:each) do
      @account = FactoryGirl.create(:account)
      @motion_active = FactoryGirl.create(:motion, :expires_at => Time.now.since(10.minutes), :account_id => @account.id)
      @motion_expired = FactoryGirl.create(:motion, :expires_at => Time.now.since(1.seconds), :account_id => @account.id)
      new_time = Time.now.since(5.minutes)
      Timecop.freeze(new_time)
    end

    it 'should respond to an expired_motions method' do
      @account.should respond_to(:expired_motions)
    end

    it "should contain only the expired motions" do
      @account.expired_motions.should_not include(@motion_active)

    end


  end

  describe "motions of the day" do
    before(:each) do
      @creator = FactoryGirl.create(:user)
      @account = FactoryGirl.create(:account)
      @user = FactoryGirl.create(:user, :default_account =>@account.id)
      @motion = FactoryGirl.create(:motion, :account_id => @account.id,
                                   :created_by => @creator.id)
      @user.vote(@motion)
      @motion.send_email
    end

    it "should return the sent motions of the day" do
      @account.motions_of_the_day.count.should > 0
    end

  end

  describe "send email to users" do
    before(:each) do
      @account = FactoryGirl.create(:account)
      @user1 = FactoryGirl.create(:user, :default_account => @account.id)
      @text = "Hello everyone"
      @subject = "subject"
    end

    it "should send an e-mail to the users" do
      lambda do
        @account.email_members(@text, @subject)
      end.should change(ActionMailer::Base.deliveries, :count).by(@account.users.count)
    end

    it "should not send an e-mail if the user has unsubscribed" do
      user = FactoryGirl.create(:user, :default_account => @account.id, :email_notify => false)
      lambda do
        @account.email_members(@text, @subject)
      end.should change(ActionMailer::Base.deliveries, :count).by(@account.users.select {|user| user.email_notify}.count)
    end

  end

end
