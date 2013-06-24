class CreateNoiseUsers < ActiveRecord::Migration
  def change
  	drop_table :noise_users
    create_table :noise_users do |t|
      t.integer :noise_id
      t.integer :user_id

      t.timestamps
    end

  end
end
