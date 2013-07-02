require 'spec_helper'

describe SessionsController do
	render_views

	describe "GET 'new'" do

		it 'should be successful' do
			get :new
			response.should be_success
		end

		describe "if there is no session" do
			
			it 'should show the login form if there is no session' do
				get :new
				response.body.should have_field('session_email')
			end

			it 'should not show the logout button' do
				get :new
				response.body.should_not have_link("Log out", href: logout_path)
			end

		end

		describe "if there is a session" do
			before(:each) do
				@account = FactoryGirl.create(:account)
				@user = FactoryGirl.create(:user, :account_id => @account.id)
				test_sign_in(@user)
			end

			it 'should redirect straight to the home page if there is a session' do
				get :new
				response.should redirect_to motions_path
			end

		end

	end

	describe "POST 'create'" do
		before(:each) do
			@account = FactoryGirl.create(:account)
			@user1 = FactoryGirl.create(:user, :account_id => @account.id)
		end

		describe "success" do

			before(:each) do
				@attr = {:email => @user1.email}
			end

			it "should create a new session based on the user id" do
				post :create, :session => @attr
				session[:user_id].should == @user1.id
				
			end

			it "should find the correct user" do
				post :create, :session => @attr
				assigns(:user).should == @user1
			end

			it "should redirect to the user's page" do
				post :create, :session => @attr
				response.should redirect_to motions_path

			end

		end

		describe "failure" do

			before(:each) do
				@attr = {:email => "test@supertest"}
			end

			it "should render the new session page" do
				post :create, :session => @attr
				response.should render_template('new')
			end

			it "should flash an error message" do
				post :create, :session => @attr
				flash.now[:error].should =~ /invalid/i
			end

		end

	end

	describe "delete 'destroy'" do
		before(:each) do
			@account = FactoryGirl.create(:account)
			@user = FactoryGirl.create(:user, :account_id => @account.id)
			test_sign_in(@user)
		end

		it "should destroy the session (log the user out)" do
			delete :destroy
			session[:user_id].should be_nil
		end

		it "should redirect to the root page" do
			delete :destroy
			response.should redirect_to root_path
		end

	end

end
