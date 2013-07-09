class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :account_id
      t.string :name
      t.string :email
      t.string :team
      t.boolean :admin

      t.timestamps
    end
  end
end
