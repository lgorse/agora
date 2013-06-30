class ChangeNoisesAgreeTextColumnToJoinText < ActiveRecord::Migration
  def change
  	rename_column :noises, :agree_text, :join_text
  end
end
