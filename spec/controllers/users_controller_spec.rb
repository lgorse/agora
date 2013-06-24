require 'spec_helper'

describe UsersController do
	render_views

	describe "get 'show'" do
		
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it 'should be successful' do
			get :show, :id => session[:user_id]
			response.should be_success

		end

		it "should get the user from the session" do
			get :show, :id => session[:user_id]
			@user.id.should == session[:user_id]			
		end

		it 'should show the logout button' do
			get :show, :id => session[:user_id]
			response.body.should have_link('Log out', href: logout_path)

		end

		

	end

end
