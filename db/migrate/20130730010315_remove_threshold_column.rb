class RemoveThresholdColumn < ActiveRecord::Migration
  def change
  	remove_column :motions, :threshold
  end
end
