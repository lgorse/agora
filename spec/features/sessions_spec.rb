require 'spec_helper'

describe "Sessions" do
	describe "GET /sessions/new" do
		before(:each) do
			@account = FactoryGirl.create(:account)
			@user = FactoryGirl.create(:user, 
									   :account_id => @account.id,
									   :email => "test@tester.com")
			visit root_path
		end

		it "should allow the user login regardless of caps" do
			fill_in 'Email', :with => @user.email.upcase
			click_button 'Sign in'
			current_path.should == '/motions'
		end


	end

end