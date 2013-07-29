class InvitationsController < ApplicationController
	include InvitationsHelper
	before_filter :authenticate


	def new
		

	end

	def create
		@valid_emails, @invalid_emails = parse_emails(params[:email_list])
		@valid_emails.each {|email| Invitation.create(:inviter_id => @current_user.id, :account_id => @account.id, 
									:email => email, :message => params[:message])}
	end
end
