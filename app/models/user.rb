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
  

  has_many :motion_users
  has_many :motions, :through => :motion_users
  belongs_to :account

  def join(motion)
  	MotionUser.create(:user_id => id, :motion_id => motion.id)
  end

  def unjoin(motion)
    motion_users.find_by_motion_id(motion).destroy
  end

  def current_motion
    motions.first(:conditions => ["expires_at >= ?", Time.now])
  end

end
