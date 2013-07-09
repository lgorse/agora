class RenameNoiseToMotion < ActiveRecord::Migration
  def change
   	rename_column :motion_users, :noise_id, :motion_id
  end
end
