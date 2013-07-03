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

	describe 'GET "index"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it "should be successful" do
			get :index
			response.should be_successful
		end

		it "should respond to the active motions variable" do
			get :index
			assigns(:active_motions).should_not == nil
		end

		it "should show the motions title" do
			motion = FactoryGirl.create(:motion, :account_id => @user.account_id)
			@user.join(motion)
			get :index
			response.body.should have_content(motion.title)
		end

	end

	describe 'GET "current"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@motion = FactoryGirl.create(:motion, :account_id => @user.account_id)
			test_sign_in(@user)
		end

		it "should be successful" do
			get :current
			response.should be_successful

		end

		it "should respond to the active motions variable" do
			get :current
			assigns(:active_motions).first.should == @motion

		end

		it "should show the current motions" do
			get :current
			response.body.should have_content(@motion.title)
		end

	end

	describe 'GET "expired"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
			@motion_expired = FactoryGirl.create(:motion, :expires_at => Time.now.since(1.seconds), :account_id => @user.account_id)
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


