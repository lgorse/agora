require 'spec_helper'


describe "Users" do
  	describe "GET /user" do
  		before(:each) do
        @account = FactoryGirl.create(:account)
        @user = FactoryGirl.create(:user, :default_account => @account.id)
        visit root_path
        fill_in 'Email', :with => @user.email
      end


      it "should feature a create motion button" do
        click_button 'Sign in'
        expect(page).to have_link('Start a motion')	     
      end

      describe "when there is no motion session" do

         it "motion button should link to create a new motion" do
          click_button 'Sign in'
          click_link('Start a motion')
          current_path.should == '/motions/new'
        end

     end

    describe "when there is a motion session" do
       before(:each) do
        @creator = FactoryGirl.create(:user)
        @motion = FactoryGirl.create(:motion, :account_id => @account.id,
                                     :created_by => @creator.id)
       end

      it "motion button should link to join a new motion" do
        click_button 'Sign in'
        click_button('Vote')
        current_path.should == '/motion_users'
      end
    end

    describe "when the user has already joined a motion" do
      before(:each) do
         @creator = FactoryGirl.create(:user)
        @motion = FactoryGirl.create(:motion, :account_id => @account.id,
                                     :created_by => @creator.id)
        click_button 'Sign in'
        click_button 'Vote'
        visit root_path
        
      end

      it "should show a cancel button" do
        expect(page).to have_button('Cancel')
      end

      it 'cancel button should link to motion_user destroy' do
        motion_user = @user.motion_users.find_by_motion_id(@motion.id)
        click_button 'Cancel'
        current_path.should == '/motion_users/' + motion_user.id.to_s
      end

    end


  end
end


