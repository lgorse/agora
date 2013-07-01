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

  describe "active motion" do
    before(:each) do
      @account = FactoryGirl.create(:account)
    end

    it "should return the current active motion" do
       @motion = FactoryGirl.create(:motion, :account_id =>  @account.id)
       @account.active_motions.first.should == @motion
    end

    it "should return nil if there is no active motion" do
        @account.active_motions.should be_blank
    end

  end

  describe "motions of the day" do
    before(:each) do
      @account = FactoryGirl.create(:account)
      @user = FactoryGirl.create(:user, :account_id =>@account.id)
      @motion = FactoryGirl.create(:motion, :account_id => @account.id)
      @user.join(@motion)
      @motion.send_email
    end

    it "should return the sent motions of the day" do
    @account.motions_of_the_day.count.should > 0
    end

  end
end
