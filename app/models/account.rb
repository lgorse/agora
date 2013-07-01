# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Account < ActiveRecord::Base
	attr_accessible :name
	validates :name, :presence => true, :uniqueness => true
	has_many :users
	has_many :motions, :dependent => :destroy


	def has_active_motions
		motions.where("expires_at >= :now", :now => Time.now).exists?
	end

	def active_motions
		motions.where("expires_at >= :now", :now => Time.now)
	end

	def motions_of_the_day
		motions.where(:email_time => Time.now.beginning_of_day()..Time.now)
	end

end
