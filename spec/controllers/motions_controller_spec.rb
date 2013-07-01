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

	describe 'GET "new"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it "should create a new motion object" do
			get :new
			assigns(:motion).new_record?.should == true
		end

	end

end
