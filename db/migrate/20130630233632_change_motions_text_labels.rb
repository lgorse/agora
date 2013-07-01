class ChangeMotionsTextLabels < ActiveRecord::Migration
  def change
  	rename_column :motions, :join_text, :title
  	rename_column :motions, :create_text, :details
  	remove_column :motions, :cancel_text
  end
end
