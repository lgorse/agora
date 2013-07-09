class ChangeAccountToAccountId < ActiveRecord::Migration
  def change
  	rename_column :users, :account, :account_id
  end
end
