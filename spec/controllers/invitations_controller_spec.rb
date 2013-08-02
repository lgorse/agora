require 'spec_helper'

describe InvitationsController do
	render_views

	describe 'GET /new' do
		
		before(:each) do
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it "should be successful" do
			get :new
			response.should be_successful
		end

		it "should have an e-mail field" do
			get :new
			response.body.should have_field('email_list')
		end

		it "should have a message field" do
			get :new
			response.body.should have_field("message")
		end

		describe "when there are email params" do
			before(:each) do
				@emails = "stuff, super.cool"
				get :new, :emails => @emails
			end

			it "should fill the email field with the emails" do
				response.body.should have_field('email_list', :text => @emails)
			end

		end

	end

	describe 'POST /create' do
		before(:each) do
			@emails = "super@hotdog.com, power@crunch.buns, buns, print"
			@message = "hello, world"
			@user = FactoryGirl.create(:user)
			test_sign_in(@user)
		end

		it "should differentiate valid e-mails from invalid e-mails" do
			post :create, :email_list => @emails, :message => @message
			assigns(:valid_emails).should_not include("print")
		end

		it "should create new invitations from the valid e-mails" do
			post :create, :email_list => @emails, :message => @message
			assigns(:valid_emails).each do |email|
				Invitation.find_by_email(email).should_not == nil
			end
		end

		it "should not create invitations from the invalid e-mails " do
			post :create, :email_list => @emails, :message => @message
			assigns(:invalid_emails).each do |email|
				Invitation.find_by_email(email).should == nil
			end
		end

		it "should start async jobs to e-mail invitees" do
			lambda do
				post :create, :email_list => @emails, :message => @message
			end.should change(InviteWorker.jobs, :size).by(2)

		end

	end

	describe "GET /index" do
		before(:each) do
			@inviter = FactoryGirl.create(:user)
			@user = FactoryGirl.create(:user)
			@invitation =  Invitation.create(:inviter_id => @inviter.id,
											 :email => @user.email,
											 :account_id => @inviter.default_account)
			test_sign_in(@user)
		end

		it "should show the user's pending invitations" do
			get :index
			assigns(:pending_invitations).should include(@invitation)
		end

	end

end
