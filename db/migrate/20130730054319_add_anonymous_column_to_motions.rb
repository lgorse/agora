class AddAnonymousColumnToMotions < ActiveRecord::Migration
  def change
  	add_column :motions, :anonymous, :boolean, :default => true
  end
end
