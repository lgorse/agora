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
	has_many :noises, :dependent => :destroy

	def has_active_noise
		noises.where("expires_at >= :now", :now => Time.now).exists?
	end

	def active_noise
		noises.first(:conditions => ["expires_at >= ?", Time.now])
	end

	def noises_of_the_day
		noises.where(:email_time => Time.now.beginning_of_day()..Time.now)
	end

end
