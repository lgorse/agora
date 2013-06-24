require 'spec_helper'

describe NoiseUsersController do
	render_views

	describe "DELETE 'destroy'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@noise = FactoryGirl.create(:noise, :account_id => @user.account_id)
			test_sign_in(@user)
			@user.join(@noise)
		end

		it "should reduce the Noise_User count by 1" do
			lambda do
				delete :destroy, :id => @noise.id
			end.should change(NoiseUser, :count).by(-1)
		end

	end

	describe "POST 'create'" do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@user2 = FactoryGirl.create(:user, :account_id => @user.account_id)
			@noise = FactoryGirl.create(:noise, :account_id => @user.account_id, :threshold => 2)
			test_sign_in(@user)
			@user.join(@noise)
		end

		it "should check the threshold"  do

		end

		it "should send an e-mail if threshold has been met" do

		end

		it "should not send an e-mail if threshold has not been met" do

		end

		it "should not send an e-mail if one has already been met" do

		end

	end
end
