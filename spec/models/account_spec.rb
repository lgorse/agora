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

    it "should have a noise attribute" do
      @account.should respond_to(:noises)
    end

    it "should have the correct noise attribute" do
      @noise = FactoryGirl.create(:noise, :account_id => @account.id)
      @account.noises.first.should == @noise
    end

    it "should destroy all noises if destroyed" do
      @noise = FactoryGirl.create(:noise, :account_id => @account.id)
      @account.destroy
      Noise.find_by_id(@noise.id).should be_nil
    end

  end

  describe "has active noise" do
    before(:each) do
      @account = FactoryGirl.create(:account)
      
    end

    it 'should return true if there is an active noise' do
      @noise = FactoryGirl.create(:noise, :account_id =>  @account.id)
      @account.has_active_noise.should == true
    end

    it 'should return false if there is not an active noise ' do
      @account.has_active_noise.should == false

    end

  end

  describe "active noise" do
    before(:each) do
      @account = FactoryGirl.create(:account)
    end

    it "should return the current active noise" do
       @noise = FactoryGirl.create(:noise, :account_id =>  @account.id)
       @account.active_noise.should == @noise
    end

    it "should return nil if there is no active noise" do
        @account.active_noise.should == nil
    end

  end
end
