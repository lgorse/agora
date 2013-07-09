class ChangeTimeToDatetimeInModels < ActiveRecord::Migration
  def change
  	remove_column	:motions, :expires_at
  	remove_column :motions, :email_time
  	add_column	:motions, :expires_at,	:datetime
  	add_column	:motions, :email_time,	:datetime, :default => nil
  end
end
