require 'spec_helper'


describe "Users" do
  	describe "GET /user" do
  		before(:each) do
        @account = FactoryGirl.create(:account)
        @user = FactoryGirl.create(:user, :account_id => @account.id)
        visit root_path
        fill_in 'Email', :with => @user.email
      end


      it "should feature a noise button" do
        click_button 'Sign in'
        expect(page).to have_button('Create')	     
      end

      describe "when there is no noise session" do

         it "noise button should link to create a new noise" do
          click_button 'Sign in'
          click_button('Create')
          current_path.should == '/noises'
        end

        

     end

    describe "when there is a noise session" do
       before(:each) do
        @noise = FactoryGirl.create(:noise, :account_id => @account.id)
       end

      it "noise button should link to join a new noise" do
        click_button 'Sign in'
        click_button('Join')
        current_path.should == '/noise_users'
      end
    end

    describe "when the user has already joined a noise" do
      before(:each) do
        @noise = FactoryGirl.create(:noise, :account_id => @account.id)
        click_button 'Sign in'
        click_button 'Join'
        visit root_path
        
      end

      it "should show a cancel button" do
        expect(page).to have_button('Cancel')
      end

      it 'cancel button should link to noise_user destroy' do
        noise_user = @user.current_noise
        click_button 'Cancel'
        current_path.should == '/noise_users/' + @noise.id.to_s
      end

    end

    describe "when the noise e-mail has been sent" do
      before(:each) do
        @noise = FactoryGirl.create(:noise, :account_id => @account.id)
        @noise.send_email
        
      end

      it "should show text and no button" do
        click_button 'Sign in'
        expect(page).to have_content('Quiet!')

      end

    end

  end
end


