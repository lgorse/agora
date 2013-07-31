# == Schema Information
#
# Table name: replies
#
#  id         :integer          not null, primary key
#  motion_id  :integer
#  user_id    :integer
#  text       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Reply do

	describe "validations" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion)
			@attr = {:user_id => @user.id, :motion_id => @motion.id, :text => "riverrun, past eves and Adams"}
		end

		it "should require a text" do
			reply = Reply.new(@attr.merge(:text => ""))
			reply.should_not be_valid
		end

		it "should require a user" do
			reply = Reply.new(@attr.merge(:user_id => @user.id+1))
			reply.should_not be_valid
		end

		it "should require a motion" do
			reply = Reply.new(@attr.merge(:motion_id => ""))
			reply.should_not be_valid
		end

		it "should be ordered in reverse chronological order" do
			reply = Reply.create(@attr)
			reply2 = Reply.create(@attr.merge(:text => "Obladdee"))
			Reply.first.should == reply2
		end
	end

	describe "attributes" do
		before(:each) do
			@reply =  FactoryGirl.create(:reply)
		end

		it "should respond to a user attribute" do
			@reply.should respond_to(:motion)

		end

		it "should respond to a motion attribute" do
			@reply.should respond_to(:motion)
		end

	end
end
