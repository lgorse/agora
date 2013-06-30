require 'spec_helper'


describe "Users" do
  	describe "GET /user" do
  		before(:each) do
        @account = FactoryGirl.create(:account)
        @user = FactoryGirl.create(:user, :account_id => @account.id)
        visit root_path
        fill_in 'Email', :with => @user.email
      end


      it "should feature a motion button" do
        click_button 'Sign in'
        expect(page).to have_button('Create')	     
      end

      describe "when there is no motion session" do

         it "motion button should link to create a new motion" do
          click_button 'Sign in'
          click_button('Create')
          current_path.should == '/motions'
        end

        

     end

    describe "when there is a motion session" do
       before(:each) do
        @motion = FactoryGirl.create(:motion, :account_id => @account.id)
       end

      it "motion button should link to join a new motion" do
        click_button 'Sign in'
        click_button('Join')
        current_path.should == '/motion_users'
      end
    end

    describe "when the user has already joined a motion" do
      before(:each) do
        @motion = FactoryGirl.create(:motion, :account_id => @account.id)
        click_button 'Sign in'
        click_button 'Join'
        visit root_path
        
      end

      it "should show a cancel button" do
        expect(page).to have_button('Cancel')
      end

      it 'cancel button should link to motion_user destroy' do
        motion_user = @user.current_motion
        click_button 'Cancel'
        current_path.should == '/motion_users/' + @motion.id.to_s
      end

    end

    describe "when the motion e-mail has been sent" do
      before(:each) do
        @motion = FactoryGirl.create(:motion, :account_id => @account.id)
        @motion.send_email
        
      end

      it "should show text and no button" do
        click_button 'Sign in'
        expect(page).to have_content('Quiet!')

      end

    end

  end
end


