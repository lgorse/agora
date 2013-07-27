require 'spec_helper'

describe MotionUsersController do
	render_views

	describe "DELETE 'destroy'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@motion = FactoryGirl.create(:motion, :account_id => @account.id)
			@user.vote(@motion)
		end

		it "should reduce the motion_User count by 1" do
			lambda do
				delete :destroy, :id => @motion.id
			end.should change(MotionUser, :count).by(-1)
		end

	end

	describe "POST 'create'" do

		describe "if threshold has been met" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				@user2 = FactoryGirl.create(:user, :default_account => @user.default_account)
				@motion = FactoryGirl.create(:motion, :account_id => @user.default_account, :threshold => 2)
				test_sign_in(@user)
				@motion_user = {:user_id => @user2.id, :motion_id => @motion.id}
			end

			it "should add a motion user entity" do
				lambda do 
					post :create, :motion_user => @motion_user
				end.should change(MotionUser, :count).by(1)

			end

		end

		describe 'if threshold has not been met' do
			before(:each) do
				@user = FactoryGirl.create(:user)
				@user2 = FactoryGirl.create(:user, :default_account => @user.default_account)
				@motion = FactoryGirl.create(:motion, :account_id => @user.default_account, :threshold => 3)
				test_sign_in(@user)
				@motion_user = {:user_id => @user2.id, :motion_id => @motion.id}
			end


			it "should not send an e-mail if threshold has not been met" do
				lambda do
					post :create, :motion_user => @motion_user
				end.should change(ActionMailer::Base.deliveries, :count).by(0)

			end

		end

	end
end
