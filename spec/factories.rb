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
		email		"test@tester.com"
		team		"team"
		admin		0
		association :account
	end

end

FactoryGirl.define do
	factory :noise do 
		association	:account
		created_by	2
		expires_at	Time.now.since(5.minutes)
		threshold		10
		create_text	"Create"
		agree_text	"Join"
		cancel_text	"Cancel"
	end

end
