class ChangeAccountToAccountId < ActiveRecord::Migration
  def change
  	rename_column :users, :account, :account_id
  	rename_column :noises, :account, :account_id
  end
end
