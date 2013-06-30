
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
		name		"tester"
		email		{generate(:email)}
		team		"team"
		admin		0
		association :account
	end

end

FactoryGirl.define do

	sequence :email do |n|
		"test#{n}@tester.com"
	end

end

FactoryGirl.define do
	factory :noise do 
		association	:account
		created_by	2
		expires_at	{Time.now.since(5.minutes)}
		threshold		10
		create_text	"Create"
		join_text	"Join"
		cancel_text	"Cancel"
		email_sent	false
		email_time	""
	end

end

FactoryGirl.define do
	factory :noise_user do
		user_id		12
		noise_id	2
	end

	end
