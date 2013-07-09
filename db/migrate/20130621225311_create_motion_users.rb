class CreateMotionUsers < ActiveRecord::Migration
  def change
  	
    create_table :motion_users do |t|
      t.integer :noise_id
      t.integer :user_id

      t.timestamps
    end

  end
end
