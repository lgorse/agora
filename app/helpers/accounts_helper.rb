module AccountsHelper

	def account_users_count
		@current_user.account.users.count
	end
end
