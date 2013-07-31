
FactoryGirl.define do
	factory :account do 
		name	{generate(:name)}
	end
end

FactoryGirl.define do
	sequence :name do |n|
		"test_name#{n}"
	end
end


FactoryGirl.define do
	factory :user do
		name			"tester"
		email			{generate(:email)}
		team			"team"
		admin			false
		default_account {FactoryGirl.create(:account).id}
		email_notify	true
	end
end

FactoryGirl.define do
	sequence :email do |n|
		"test#{n}@tester.com"
	end

end

FactoryGirl.define do
	factory :motion do 
		association	:account
		created_by	2
		expires_at	{Time.now.since(5.minutes)}
		title		"Create"
		details		"Join"
		email_sent	false
		email_time	""
	end

end

FactoryGirl.define do
	factory :motion_user do
		user_id		12
		motion_id	2
	end
end

FactoryGirl.define do
	factory :account_user do
		association 	:user
		association		:account
	end
end

FactoryGirl.define do
	factory :reply do
		association 	:user
		association 	:motion
		text			"Testing this text"
	end

end
