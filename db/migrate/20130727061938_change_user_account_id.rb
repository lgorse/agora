class ChangeUserAccountId < ActiveRecord::Migration
  def change
  	rename_column :users, :account_id, :default_account
  end
end
