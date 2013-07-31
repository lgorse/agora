module PagesHelper

	def example_motions
		attributes = {:account_id => @account.id, :created_by => @current_user.id,
				:expires_at => Time.now.since(1.hour)}
		motion_complain = Motion.new(attributes.merge(:title => "Let\'s keep the studio clean", 
									 				  :details => "Especially the week-old food in the fridge!"))
		motion_complain.id = 1
		motion_idea = Motion.new(attributes.merge(:title => 'Should we do a regular Friday happy hour?',
												  :details => "I feel we need to know each other better",
												  :anonymous => false))	
		motion_idea.id = 2
		@example_motions = [motion_complain, motion_idea]
		@example_motions.each {|motion| motion.created_at = Time.now.ago(1.hour)}


	end
end
