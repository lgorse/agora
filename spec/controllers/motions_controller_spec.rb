require 'spec_helper'

describe MotionsController do

	describe 'POST "create"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it "should create a new motion" do
			lambda do
				post :create
			end.should change(Motion, :count).by(1)
		end

	end

end
