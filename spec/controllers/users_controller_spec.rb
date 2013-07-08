require 'spec_helper'

describe UsersController do
	render_views

	describe "get 'show'" do
		
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@motion1 = FactoryGirl.create(:motion, 
				:created_by => @user.id, 
				:account_id => @user.account_id)
			@motion2 = FactoryGirl.create(:motion, 
				:account_id => @user.account_id)
			@user.join(@motion2)
			get :show, :id => session[:user_id]
		end

		it 'should be successful' do
			response.should be_success
		end

		it "should get the user from the session" do			
			@user.id.should == session[:user_id]			
		end

		it 'should show the logout button' do
			response.body.should have_link('Log out', href: logout_path)
		end

		it "should feature the user name" do
			response.body.should have_css("h3", @user.name)
		end

		it "should have an 'about' link that links to show" do
			response.body.should have_link("About", user_path(@user))
		end

		it "should have a link to the user's created motions" do
			response.body.should have_link("Motions created", created_user_path(@user.id))
		end

		it "should have a link to the user's joined motions" do
			response.body.should have_link("Motions joined", motions_user_path(@user))
		end

		it "should say which account the user is with" do
			response.body.should have_css("p", :text => /#{@user.account.name}/i)
		end

		it "should say when the user joined the account" do
			response.body.should have_css("p", :text => /#{@user.created_at.strftime('%A %B %d %Y')}/i)

		end

		it "should show the user's created motion count" do
			response.body.should have_css("p", :text => /#{@user.created_motions.count}/i)

		end

		it "should show the user's joined motions count" do
			response.body.should have_css("p", :text => /#{@user.motions.count}/i)
		end

	end

	describe 'GET "user/created' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@motion1 = FactoryGirl.create(:motion, 
				:created_by => @user.id, 
				:account_id => @user.account_id)
			@motion2 = FactoryGirl.create(:motion, 
				:account_id => @user.account_id)
			@user.join(@motion2)
			get :created, :id => session[:user_id]
		end

		it "should have the number of motions the user has created" do
			response.body.should have_content(@user.created_motions.count)
		end

		it "should list the motions created by the user" do
			assigns(:user_created_motions).should == @user.created_motions
		end

	end

	describe 'GET "user/joined"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@motion1 = FactoryGirl.create(:motion, 
				:created_by => @user.id, 
				:account_id => @user.account_id)
			@motion2 = FactoryGirl.create(:motion, 
				:account_id => @user.account_id)
			@user.join(@motion2)
			get :motions, :id => session[:user_id]
		end

		it "should have the number of motions the user has joined" do
			response.body.should have_content(@user.motions.count)
		end

		it "should list the motions created by the user" do
			assigns(:user_joined_motions).should == @user.motions
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

	describe 'GET "new"' do

		describe "if the user is NOT an admin" do
			before(:each) do
				@user = FactoryGirl.create(:user, :admin => false)
				test_sign_in(@user)
				get :new
			end

			it "should not be successful" do
				response.should_not be_successful
			end

			it "should redirect the user to the root page" do
				response.should redirect_to root_path

			end

		end

		describe "if the user is an admin" do
			before(:each) do
				@user = FactoryGirl.create(:user, :admin => true)
				test_sign_in(@user)
				get :new
			end

			it "should be successful" do
				response.should be_successful
			end


			it "should have a name input" do
				response.body.should have_field('user[name]')
			end

			it "should have an e-mail input" do
				response.body.should have_field('user[email]')
			end

			it "should have a team input" do
				response.body.should have_field('user[team]')
			end

			it "should have an admin checkbox" do
				response.body.should have_field('user[admin]')
			end

			it 'should have the current user account as a hidden field' do
				response.body.should have_selector("input#user_account[value=\'"+@user.account_id.to_s+"\']")
			end

		end

	end

	describe 'POST "create"' do

		describe "if user is not an admin" do

			before(:each) do
				@user = FactoryGirl.create(:user, :admin => false)
				test_sign_in(@user)
				@attr = {:name => "tester", :email => "test@tester.edu", :admin => false,  :team => "test", :account => @user.account_id}
				post :create, :user => @attr
			end

			it "should not be successful" do
				response.should_not be_successful
			end

			it "should redirect the user to the root page" do
				response.should redirect_to root_path

			end

		end

		describe "if user is an admin" do
			before(:each) do
				@user = FactoryGirl.create(:user, :admin => true)
				test_sign_in(@user)
			end

			describe "if the input is well formed" do
				before(:each) do
					@attr = {:name => "tester", :email => "test75@tester.edu", :admin => false,  :team => "test", :account => @user.account_id}
				end

				it "should create a new user" do
					lambda do
						post :create, :user => @attr
					end.should change(User, :count).by(1)
				end

				it "should redirect to the new user page" do
					post :create, :user => @attr
					response.should redirect_to user_path(assigns(:user))
				end

			end

			describe "if the input is badly formed" do
				before(:each) do
					@attr = {:name => "tester", :email => "test@tester", :admin => false,  :team => "test", :account => @user.account_id}
					post :create, :user => @attr
				end

				it "should not create a new user" do
					lambda do
						post :create, :user => @attr
					end.should_not change(User, :count)

				end

				it "should re-render the new page to show error messages" do
					post :create, :user => @attr
					response.should render_template('new')
				end
			end

		end



	end


end

