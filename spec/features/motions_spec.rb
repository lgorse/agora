require 'spec_helper'

describe "Motions" do
	describe "GET /motions/new" do
		before(:each) do
			@account = FactoryGirl.create(:account)
			@user = FactoryGirl.create(:user, :default_account => @account.id)
			visit root_path
			fill_in 'Email', :with => @user.email
			click_button 'Sign in'
			click_link ('Start a motion')
		end

		it "should feature a title input" do
			expect(page).to have_field("Title")
		end

		it "should feature a character limit number for the title" do
			expect(page).to have_content(TITLE_CHAR_MAX)
		end

		it "should feature a details input" do
			expect(page).to have_field("Details")
		end

		it "should feature a character limit number for the details" do
			expect(page).to have_content(DETAILS_CHAR_MAX)
		end

		it 'should feature a threshold input' do
			expect(page).to have_field("Threshold")
		end

		it 'should feature an expiration input' do
			expect(page).to have_field("Expires")
		end

		it "should redirect to root path if the create button is clicked" do
			fill_in 'Title', :with => 'Hello'
			click_button 'Create'
			current_path.should == '/motions'

		end

	end

end