module AccountsHelper

	def account_users_count
		@account.users.count
	end
end
