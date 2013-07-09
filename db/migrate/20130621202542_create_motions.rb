class CreateMotions < ActiveRecord::Migration
  def change
    create_table :motions do |t|
      t.integer :created_by
      t.integer :account_id
      t.datetime :expires_at
      t.integer :threshold
      t.string :details
      t.string :title
      t.boolean :email_sent
      t.datetime  :email_time, :default => nil
      t.timestamps
    end
  end
end
