# == Schema Information
#
# Table name: account_users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe AccountUser do

  describe "associations" do
  	before(:each) do
      @account_user = FactoryGirl.create(:account_user)
    end

    it "should have a user attribute" do
      @account_user.should respond_to(:user)
    end

    it "should have an account attribute" do
      @account_user.should respond_to(:account)
    end

  end

  describe 'validations' do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end

    it "should have a user id" do
      account_user = AccountUser.new(:user_id => "", :account_id => @user.default_account)
      account_user.should_not be_valid
    end

    it "should have an account id" do
      account_user = AccountUser.new(:user_id => @user.id, :account_id => "")
      account_user.should_not be_valid
    end

    it "should not allow duplications" do
      account_user1 = AccountUser.create(:user_id => @user.id, :account_id => @user.default_account)
      account_user2 = AccountUser.new(:user_id => @user.id, :account_id => @user.default_account)
      account_user2.should_not be_valid
    end

  end

end
