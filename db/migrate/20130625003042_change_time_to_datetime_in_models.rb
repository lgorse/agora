class ChangeTimeToDatetimeInModels < ActiveRecord::Migration
  def change
  	remove_column	:noises, :expires_at
  	remove_column :noises, :email_time
  	add_column	:noises, :expires_at,	:datetime
  	add_column	:noises, :email_time,	:datetime, :default => nil
  end
end
