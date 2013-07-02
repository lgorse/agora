module PagesHelper

	def example_motions
		attributes = {:account_id => @current_user.account_id, :created_by => @current_user.id,
				:expires_at => Time.now.since(1.hour), :threshold => 5}
		motion_complain = Motion.new(attributes.merge(:title => "Let\'s keep the studio clean", 
									 				  :details => "Especially the week-old food in the fridge!"))
		motion_idea = Motion.new(attributes.merge(:title => 'Should we do a happy hour this Friday?',
												  :details => "Let\'s see who\'s up for contributing $5 to the cause"))
		@example_motions = [motion_complain, motion_idea]

	end
end
