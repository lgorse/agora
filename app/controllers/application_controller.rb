class ApplicationController < ActionController::Base
  protect_from_forgery

  include SessionsHelper
  before_filter :flasheroo

  def flasheroo
  	if cookies[:flash]
  	flash.now[:notice] = "#{view_context.link_to('Invite new members to your community', new_invitation_path)}"
  end

  end
  
end
