require 'spec_helper'

describe "Accounts" do
	describe "GET /account" do

		describe "if the user is an admin" do
			before(:each) do
				@account = FactoryGirl.create(:account)
				@user = FactoryGirl.create(:user, :default_account => @account.id, :admin => true)
				visit root_path
				fill_in 'Email', :with => @user.email
				click_button 'Sign in'
				click_link 'Admin'
			end

			it "should allow the user to link to the account view" do
				current_path.should == '/accounts/' + @account.id.to_s
			end

			it 'should allow the user to link to the new member page' do
				click_link 'Add member'
				current_path.should == '/users/new_admin'

			end

			it "should allow the user to link to the batch members view" do
				click_link 'Batch members'
				current_path.should == ('/accounts/' + @account.id.to_s + '/batch_members')
			end

		end

		describe "if user is not an admin" do
			before(:each) do
				@account = FactoryGirl.create(:account)
				@user = FactoryGirl.create(:user, :default_account => @account.id, :admin => false)
				visit root_path
				fill_in 'Email', :with => @user.email
				click_button 'Sign in'
			end

			it 'should not allow the user to link to the account view' do
				expect(page).to have_no_link('Admin')
			end

		end

	end

	describe 'GET /account/batch_members' do
		before(:each) do
				@account = FactoryGirl.create(:account)
				@user = FactoryGirl.create(:user, :default_account => @account.id, :admin => true)
				visit root_path
				fill_in 'Email', :with => @user.email
				click_button 'Sign in'
				click_link 'Admin'
				click_link 'Batch members'
			end


		it "should allow the upload of a CSV file" do
			attach_file 'batch_members', '/home/lgorse/www/agora/doc/sample.csv'
			click_button 'Upload'
			expect(page).to have_content('Upload successful')

		end


	end

	describe 'POST /account/change' do
		before(:each) do
				@user = FactoryGirl.create(:user)
				@account2 = FactoryGirl.create(:account)
				@user.join(@account2)
				visit root_path
				fill_in 'Email', :with => @user.email
				click_button 'Sign in'
				select @account2.name, :from => "account_name_header"

		end

		it "should show the current account in the account bar" do
			expect(page).to have_selector("#account_name_header", :text => @account2.name)
		end

	end

end