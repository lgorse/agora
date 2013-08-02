class SetMotionAnonymousToDefaultFalse < ActiveRecord::Migration
  def change
  	change_column :motions, :anonymous, :boolean, :default => false
  end
end
