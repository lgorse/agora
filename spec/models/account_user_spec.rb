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


  	end

  	it "should have a user attribute" do
  		pending
  	end

  	it "should have an account attribute" do
  		pending
  	end

  end

  describe 'validations' do

  	 it "should have a user id" do
pending
  	 end

  	 it "should have an account id" do
pending
  	 end

  	 it "should not allow duplications"
pending
  end
end
