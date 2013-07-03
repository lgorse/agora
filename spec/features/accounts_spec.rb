require 'spec_helper'

describe "Accounts" do
	describe "GET /account" do

		describe "if the user is an admin" do
			before(:each) do
				@account = FactoryGirl.create(:account)
				@user = FactoryGirl.create(:user, :account_id => @account.id, :admin => true)
				visit root_path
				fill_in 'Email', :with => @user.email
				click_button 'Sign in'
			end

			it "should allow the user to link to the account view" do
				click_link 'Admin'
				current_path.should == '/accounts/' + @account.id.to_s
			end

		end

		describe "if user is not an admin" do
			before(:each) do
				@account = FactoryGirl.create(:account)
				@user = FactoryGirl.create(:user, :account_id => @account.id, :admin => false)
				visit root_path
				fill_in 'Email', :with => @user.email
				click_button 'Sign in'
			end

			it 'should not allow the user to link to the account view' do
				expect(page).to have_no_link('Admin')
			end

		end

	end

end