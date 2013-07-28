# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  inviter_id :integer
#  account_id :integer
#  email      :string(255)
#  accepted   :boolean
#  invitee_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Invitation do

  describe "validations" do
  	before(:each) do
  		@user = FactoryGirl.create(:user)
  		@invitee_email = "test@invitee.com"
  		@attr = {:inviter_id => @user.id, 
       :account_id => @user.default_account,
       :email => @invitee_email}
     end

     it "should not create if the user has already joined the account" do
      invitee = FactoryGirl.create(:user, :email => @invitee_email)
      invitee.join(Account.find(@user.default_account))
      invitation = Invitation.new(@attr)
      invitation.should_not be_valid
    end

    it "should not create if there is no account id" do
      invitation = Invitation.new(@attr.merge(:account_id => ""))
      invitation.should_not be_valid
    end

    it 'should not create if there is no inviter_id' do
      invitation = Invitation.new(@attr.merge(:inviter_id => ""))
      invitation.should_not be_valid
    end

    it 'should not create if there is no email' do
      invitation = Invitation.new(@attr.merge(:email => ""))
      invitation.should_not be_valid
    end

    it "should not create if email is badly formed" do
      email_attributes = ["email@email", "email.email", "email.email@email"]
      email_attributes.each do |email|
        invitation = Invitation.new(@attr.merge(:email => email))
        invitation.should_not be_valid
      end

    end

    it "should not create if the same invitation has already been sent" do
      invitation = Invitation.create(@attr)
      another_invitation = Invitation.new(@attr)
      another_invitation.should_not be_valid
    end

  end

  describe "associations and attributes" do
  	before(:each) do
  		@user = FactoryGirl.create(:user)
  		@invitee_email = "test@invitee.com"
  		@attr = {:inviter_id => @user.id, 
       :account_id => @user.default_account,
       :email => @invitee_email}
       @invitation = @user.invitations.create!(@attr)
     end

     it "should have an invitee attribute" do
      @invitation.should respond_to(:inviter)
    end

    it "should have an inviter attribute" do
      @invitation.should respond_to(:invitee)
    end

  end

  describe "invitee" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @invitee = FactoryGirl.create(:user)
      @attr = {:inviter_id => @user.id, 
       :account_id => @user.default_account,
       :email => @invitee.email}

     end

     it "should add an invitee_id if the user is in the db" do
      invitation = @user.invitations.create!(@attr)
      invitation.invitee_id.should == @invitee.id
    end
  end

  describe "invitation e-mail" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @invitee_email = "test@invitee.com"
      @attr = {:inviter_id => @user.id, 
       :account_id => @user.default_account,
       :email => @invitee_email}
       

     end

     it "should send an invitation e-mail" do
      lambda do
        invitation = @user.invitations.create!(@attr)
      end.should change(InviteWorker.jobs, :size).by(1)
    end


     it "asynchronous invitation should send e-mail" do
      lambda do
        invitation = @user.invitations.create!(@attr)
        invite_sender = InviteWorker.new
        invite_sender.perform(invitation.id)
      end.should change(ActionMailer::Base.deliveries, :count).by(1)

    end

  end


end
