class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :account
      t.string :name
      t.string :email
      t.string :team
      t.integer :admin

      t.timestamps
    end
  end
end
