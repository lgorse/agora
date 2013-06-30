class RenameNoiseToMotion < ActiveRecord::Migration
  def change
  	rename_table :noises, :motions
  	rename_table :noise_users, :motion_users
  	rename_column :motion_users, :noise_id, :motion_id


  end
end
