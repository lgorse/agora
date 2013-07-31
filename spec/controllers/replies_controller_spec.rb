require 'spec_helper'

describe RepliesController do

	describe "get CREATE" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion)
			@attr = {:user_id => @user.id, :motion_id => @motion.id, :text => "testing"}
		end

		describe "failure" do

		it 'should require the user to be signed in' do
			post :create, :reply => @attr
			response.should redirect_to root_path
		end

	end

	describe "success" do
		before(:each) do
			test_sign_in(@user)
		end
		
		it 'should create a new motion' do
			lambda do
				post :create, :reply => @attr
			end.should change(Reply, :count).by(1)

		end

	end





	end

end
