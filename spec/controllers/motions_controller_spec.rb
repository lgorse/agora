require 'spec_helper'

describe MotionsController do
	render_views

	describe 'POST "create"' do
		before(:each) do
			@user = FactoryGirl.create(:user)
			@attr = {:title => "Hello", :details => "My friend", 
					 :expires_at => Time.now.since(1.hour), :anonymous => true}
			test_sign_in(@user)
		end

		it "should create a new motion" do
			lambda do
				post :create, :motion => @attr
			end.should change(Motion, :count).by(1)
		end

		it "should be anonymous by default" do
			post :create, :motion => @attr
			Motion.last.anonymous.should == true

		end

		it "should not be anonymous if the user decrees not" do
			post :create, :motion => @attr.merge(:anonymous => false)
			Motion.last.anonymous.should == false

		end

		it "should redirect home" do
			post :create, :motion => @attr
			response.should redirect_to(new_invitation_path(:motion => "sent"))

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
			@motion = FactoryGirl.create(:motion, :account_id => session[:account_id])
			get :index
		end

		it "should be successful" do
			
			response.should be_successful
		end


		it "should show the motions title" do
			motion = FactoryGirl.create(:motion, :account_id => session[:account_id])
			@user.vote(motion)
			response.body.should have_content(motion.title)
		end

		it "should respond to the active motions variable" do
			assigns(:active_motions).first.should == @motion
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

		describe "if there is a flash cookie"  do
			before(:each) do
				@user = FactoryGirl.create(:user)
				test_sign_in(@user)
				cookies[:flash] = "test flash"
				get :current
			end

			it "should show a notice flash" do
				flash.now[:notice].should_not == nil

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


