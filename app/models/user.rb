# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  email      :string(255)
#  team       :string(255)
#  admin      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :account_id, :admin, :email, :name, :team

  email_format = /[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :format => {:with => email_format}
  validates :name, :presence => true
  validates :account, :presence => true
  

  has_many :noise_users
  has_many :noises, :through => :noise_users
  belongs_to :account

  def join(noise)
  	NoiseUser.create(:user_id => id, :noise_id => noise.id)
  end

  def unjoin(noise)
    noise_users.find_by_noise_id(noise).destroy
  end

  def current_noise
    noises.first(:conditions => ["expires_at >= ?", Time.now])
  end

end
