class NoisesController < ApplicationController

before_filter :authenticate

	def create
		@noise = Noise.create(:created_by => @current_user.id, 
							  :account_id => @current_user.account.id, 
							  :expires_at => Time.now.since(5.minutes),
							  :threshold => 5,
							  :create_text => "It\'s too noisy here!",
							  :agree_text => 'It\'s too noisy here!',
							  :cancel_text => 'It\'s too noisy here!')
	end

	def destroy
		
	end
end
