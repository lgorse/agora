class CreateNoises < ActiveRecord::Migration
  def change
    create_table :noises do |t|
      t.integer :created_by
      t.integer :account
      t.time :expires_at
      t.integer :threshold
      t.string :create_text
      t.string :agree_text
      t.string :cancel_text

      t.timestamps
    end
  end
end
