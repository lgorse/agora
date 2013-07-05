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

	describe "admins" do

		describe "admin" do
			before(:each) do
				@user = FactoryGirl.create(:user, :admin => 1)
				test_sign_in(@user)
			end

			it 'should have an admin button on his header' do
				get :show, :id => @user.id
				response.body.should have_link('Admin')

			end


		end

		describe "non-admin" do
			before(:each) do
				@user = FactoryGirl.create(:user, :admin => 0)
				test_sign_in(@user)
			end

			it 'should not show the admin button' do
				get :show, :id => @user.id
				response.body.should_not have_link('Admin')
			end

		end

	end

	describe "create_batch_members" do
		before(:each) do
			file = File.open('/home/lgorse/www/agora/doc/sample.csv')
			@file_path = ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file))
			@account = FactoryGirl.create(:account)
			@user = FactoryGirl.create(:user, :account_id => @account.id, :admin => true)
			test_sign_in(@user)
		end

		it "should add users to the database" do
			lambda do
				post :create_batch_members, :csv => @file_path, :account_id => @account.id
			end.should change(User, :count).by(2)

		end

		it "should list the users" do
			post :create_batch_members, :csv => @file_path, :account_id => @account.id
			response.body.should have_content(assigns(:new_user_list).first.name)

		end

	end

	

end
