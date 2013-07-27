require 'spec_helper'

describe AccountsController do
	render_views

	describe 'Admin' do

		describe 'if the user is an admin of this account' do
			before(:each) do
				@user = FactoryGirl.create(:user, :admin => true)
				test_sign_in(@user)
			end

			it "should allow the user to be on an account page page" do
				get :show, :id => @account.id
				response.should be_successful
			end

		end

		describe 'if the user is an admin but not of this account' do
			before(:each) do
				@user = FactoryGirl.create(:user, :admin => true)
				test_sign_in(@user)
				@false_account = FactoryGirl.create(:account)
			end

			it "should not allow a user to be on an account page" do
				get :show, :id => @false_account.id
				response.should_not be_successful
			end

		end

		describe 'if the user is not an admin' do
			before(:each) do
				@user = FactoryGirl.create(:user, :admin => false)
				test_sign_in(@user)

			end

			it "should prevent the user from being on an account page" do
				get :show, :id => @account.id
				response.should_not be_successful
			end

			it "should redirect the user to the error page" do
				get :show, :id => @account.id
				response.should redirect_to(root_path)
			end

		end

	end

	describe 'GET /account' do
		before(:each) do
			@user = FactoryGirl.create(:user, :admin => true)
			test_sign_in(@user)
			get :show, :id => @account.id
		end

		describe "nav bar" do

			it "should have a new user link" do
				response.body.should have_link('Add member')
			end

			it "should have a batch users link" do
				response.body.should have_link('Batch members')
			end

		end

		describe "view" do

			it "should show the account users" do
				response.body.should have_content('Account members')
			end

		end

	end

	describe 'GET /account/batch_members' do

		before(:each) do
			
			@user = FactoryGirl.create(:user, :admin => true)
			test_sign_in(@user)
			get :batch_members, :id => @account.id
		end

		it "should be successful" do
			response.should be_successful
		end

	end


end
