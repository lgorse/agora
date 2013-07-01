require 'spec_helper'

describe MotionsController do
	render_views

	describe 'POST "create"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@attr = {:title => "Hello", :details => "My friend", :threshold => 5}
			test_sign_in(@user)
		end

		it "should create a new motion" do
			lambda do
				post :create, :motion => @attr
			end.should change(Motion, :count).by(1)
		end

		it "should redirect home" do
			post :create, :motion => @attr
			response.should redirect_to(root_path)

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
