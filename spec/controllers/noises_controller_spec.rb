require 'spec_helper'

describe NoisesController do

	describe 'POST "create"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it "should create a new noise" do
			lambda do
				post :create
			end.should change(Noise, :count).by(1)
		end

	end

end
