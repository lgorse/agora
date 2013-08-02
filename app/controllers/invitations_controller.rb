class InvitationsController < ApplicationController
	include InvitationsHelper
	before_filter :authenticate


	def new
		if params[:motion] == 'sent'
			@prompt = "Add new members who can vote on your motion"
		else
			@prompt = "Invite new members to Agora"
		end
	end

	def create
		@valid_emails, @invalid_emails = parse_emails(params[:email_list])
		@valid_emails.each {|email| Invitation.create(:inviter_id => @current_user.id, :account_id => @account.id, 
									:email => email, :message => params[:message])}
	end

	def accept
		@current_user.accept(Invitation.find(params[:id]))
		redirect_to invitations_path
	end

	def index
		@pending_invitations = @current_user.pending_invitations
	end
end
