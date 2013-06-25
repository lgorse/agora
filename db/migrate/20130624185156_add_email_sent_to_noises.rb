class AddEmailSentToNoises < ActiveRecord::Migration
  def change
  	add_column :noises, :email_sent, :boolean, :default => false
  end
end
