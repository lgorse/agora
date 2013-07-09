class CreateMotions < ActiveRecord::Migration
  def change
    create_table :motions do |t|
      t.integer :created_by
      t.integer :account_id
      t.time :expires_at
      t.integer :threshold
      t.string :create_text
      t.string :agree_text
      t.string :cancel_text
      t.boolean :email_sent

      t.timestamps
    end
  end
end
