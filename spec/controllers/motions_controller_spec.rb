require 'spec_helper'

describe MotionsController do
	render_views

	describe 'POST "create"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@attr = {:title => "Hello", :details => "My friend", :threshold => 5, :expires_at => Time.now.since(1.hour)}
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

	describe 'GET "index"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it "should be successful" do
			get :index
			response.should be_successful
		end


		it "should show the motions title" do
			motion = FactoryGirl.create(:motion, :account_id => session[:account_id])
			@user.vote(motion)
			get :index
			response.body.should have_content(motion.title)
		end

	end

	describe 'GET "current"' do
		describe "if there are active motions" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				test_sign_in(@user)
				@motion = FactoryGirl.create(:motion, :account_id => session[:account_id])
				
				get :current
			end

			it "should be successful" do
				response.should be_successful

			end

			it "should respond to the active motions variable" do
				assigns(:active_motions).first.should == @motion

			end

			it "should show the current motions" do
				response.body.should have_content(@motion.title)
			end

		end

		describe "if there are no active motions" do
			before(:each) do
				@user = FactoryGirl.create(:user)
				test_sign_in(@user)
				get :current
			end

			it "should show a prompt to start the first active motion" do
				response.body.should have_content(/no active motions/i)


			end

		end

	end

	describe 'GET "expired"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@motion_expired = FactoryGirl.create(:motion, :expires_at => Time.now.since(1.seconds), :account_id => session[:account_id])
			new_time = Time.now.since(5.minutes)
			Timecop.freeze(new_time)
		end

		it "should be successful" do
			get :expired
			response.should be_successful
		end

		it "should respond to the expired motions variable" do
			get :expired
			assigns(:expired_motions).should_not == nil

		end

		it "should show the expired motions" do
			get :expired
			response.body.should have_content(@motion_expired.title)
		end

	end

end


