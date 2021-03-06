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

	end

	describe 'GET /account' do
		before(:each) do
			@user = FactoryGirl.create(:user, :admin => false)
			test_sign_in(@user)
			@user2 = FactoryGirl.create(:user)
			@user2.join(Account.find(@user.default_account))
			get :show, :id => @account.id

		end

		describe 'if the user is an admin' do
			before(:each) do
				@user.update_attributes(:admin => true)
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
		end

		describe 'if the user is not an admin' do
			before(:each) do
				get :show, :id => @account.id
			end

			describe 'nav bar' do

				it "should not have a new user link" do
					response.body.should_not have_link('Add member')
				end

				it "should not have a batch users link" do
					response.body.should_not have_link('Batch members')
				end

			end

		end
		

		describe "view" do
			before(:each) do
				get :show, :id => @account.id

			end

			it "should show the account users" do
				response.body.should have_content(@user2.name)
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

	describe 'POST /account/change' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@account2 = FactoryGirl.create(:account)
			@user.join(@account2)
			test_sign_in(@user)
			session[:return_to] = (FULL_ROOT_URL + '/users/' + @user.id.to_s).to_s
		end

		describe 'if successful' do
			before(:each) do
				
				post :change, :account_id => @account2.id
			end

			it "should change the session account" do
				session[:account_id].to_i.should == @account2.id
			end

			it "should redirect to the root path" do
				response.should redirect_to(motions_path)
			end

			it "should change the account instance variable" do
				assigns(:account).should == @account2
			end

		end

		describe 'if failed' do
			before(:each) do
				post :change, :account_id => (@account2.id+1)
			end

			it "should not change the account" do
				session[:account_id].to_i.should == @user.default_account
			end

			it 'should redirect to the root path' do
				response.should redirect_to(root_path)
			end

			it 'should show an error message' do
				pending 'setting up a regular flash messaging format'
			end

		end

	end


end
