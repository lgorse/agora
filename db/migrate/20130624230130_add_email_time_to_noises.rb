class AddEmailTimeToNoises < ActiveRecord::Migration
  def change
  	add_column :noises, :email_time, :time, :default => nil
  end
end
