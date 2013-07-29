class InvitationsController < ApplicationController
	include InvitationsHelper
	before_filter :authenticate


	def new
		

	end

	def create
		@valid_emails, @invalid_emails = parse_emails(params[:email_list])


	end
end
